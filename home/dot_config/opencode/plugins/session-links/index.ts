import { homedir } from "node:os"
import { join } from "node:path"
import { readdir, rm, mkdir, readFile, stat, writeFile } from "node:fs/promises"
import { Plugin } from "@opencode/plugin"

type Report = { tickets: string[]; mrs: string[] }

const PRUNE_AFTER_MS = 30 * 24 * 60 * 60 * 1000

const dir = () => join(homedir(), ".local", "state", "opencode", "session-links")
const path = (sessionID: string) => join(dir(), `${sessionID}.json`)

// Report files stop being written when their session ends, so the file
// mtime is a good "last activity" signal.
async function prune() {
  let files: string[]
  try {
    files = await readdir(dir())
  } catch {
    return
  }
  for (const file of files) {
    if (!file.endsWith(".json")) continue
    try {
      const p = join(dir(), file)
      const stats = await stat(p)
      if (Date.now() - stats.mtimeMs > PRUNE_AFTER_MS) await rm(p)
    } catch {
      // Concurrently deleted or unreadable: skip until the next prune.
    }
  }
}

async function readReport(sessionID: string): Promise<Report> {
  try {
    return { tickets: [], mrs: [], ...JSON.parse(await readFile(path(sessionID), "utf8")) }
  } catch {
    return { tickets: [], mrs: [] }
  }
}

async function writeReport(sessionID: string, report: Report) {
  await mkdir(dir(), { recursive: true })
  await writeFile(path(sessionID), JSON.stringify(report))
}

const LINEAR_URL = /linear\.app\/[^/\s"')]+\/issue\/([A-Za-z0-9][A-Za-z0-9_]*-\d+)/g
const MR_URL = /https?:\/\/[^\s"'<()]+\/-\/merge_requests\/\d+|https?:\/\/(?:www\.)?github\.com\/[\w.-]+\/[\w.-]+\/pull\/\d+/g

// URLs only: bare ticket ids (ABC-123) are too false-positive-prone to
// auto-report, so the agent self-reports those via links_report.
async function reportSeen(sessionID: string, text: string) {
  const report = await readReport(sessionID)
  const prev = new Set([...report.tickets, ...report.mrs])
  const fresh = [...text.matchAll(LINEAR_URL), ...text.matchAll(MR_URL)].map((m) => m[0]).filter((url) => !prev.has(url))
  if (fresh.length === 0) return
  const mrs = new Set(report.mrs)
  const tickets = new Set(report.tickets)
  for (const url of fresh) {
    if (url.includes("linear.app")) tickets.add(url.match(/issue\/([A-Za-z0-9_]+-\d+)/)![1].toUpperCase())
    else mrs.add(url)
  }
  await writeReport(sessionID, { tickets: [...tickets], mrs: [...mrs] })
}

export default Plugin.define({
  id: "local.session-links",
  async setup(ctx) {
    void prune()
    // Auto-report MR/PR/Linear URLs the first time they appear in tool output.
    await ctx.tool.hook("execute.after", (event) => {
      if (event.status !== "completed") return
      void reportSeen(event.sessionID, JSON.stringify(event.result)).catch(() => {})
    })

    await ctx.tool.transform((editor) => {
      editor.namespace({ name: "links", description: "Session sidebar links" })
      editor.add({
        name: "report",
        description:
          "Report Linear tickets that this session opened or is working on, so they appear in the sidebar. " +
          "MRs and PRs are picked up automatically; use this tool for bare ticket ids. " +
          "Call again later to add more entries; earlier entries are kept.",
        input: {
          type: "object",
          properties: {
            tickets: { type: "array", items: { type: "string" }, description: "Linear ticket identifiers, e.g. ABC-123" },
          },
          additionalProperties: false,
        },
        options: { namespace: "links" },
        execute: async (input, context) => {
          const prev = await readReport(context.sessionID)
          const next = { tickets: [...new Set([...prev.tickets, ...(input.tickets ?? [])])], mrs: prev.mrs }
          await writeReport(context.sessionID, next)
          return { content: `Recorded ${next.tickets.length} ticket(s) for the sidebar.` }
        },
      })
    })
  },
})
