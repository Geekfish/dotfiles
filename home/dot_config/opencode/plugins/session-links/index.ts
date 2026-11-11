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

// Backslash is excluded because the text is JSON-encoded: newlines arrive as a
// literal "\n", which would otherwise glue consecutive URLs into one match.
const MR_URL = /https?:\/\/[^\s"'<()\\]+\/-\/merge_requests\/\d+|https?:\/\/(?:www\.)?github\.com\/[\w.-]+\/[\w.-]+\/pull\/\d+/g

// Only tools that create or push to an MR. Any other output (lists, logs,
// skill text) mentions MRs the session isn't working on.
const MR_TOOL = /(^|\.)(save_merge_request|create_merge_request|create_pull_request)$/
const MR_COMMAND = /\b(glab mr create|gh pr create|git push)\b/

function createsMR(tool: string, input: unknown) {
  if (MR_TOOL.test(tool)) return true
  const command = (input as { command?: unknown } | undefined)?.command
  return tool === "shell" && typeof command === "string" && MR_COMMAND.test(command)
}

async function reportMRs(sessionID: string, text: string) {
  const found = [...text.matchAll(MR_URL)].map((m) => m[0])
  if (found.length === 0) return
  const report = await readReport(sessionID)
  const mrs = new Set([...report.mrs, ...found])
  if (mrs.size === report.mrs.length) return
  await writeReport(sessionID, { ...report, mrs: [...mrs] })
}

export default Plugin.define({
  id: "local.session-links",
  async setup(ctx) {
    void prune()
    // Tickets are not auto-reported: Linear URLs show up in search results and
    // skill examples far more often than for tickets the session works on.
    await ctx.tool.hook("execute.after", (event) => {
      if (event.status !== "completed" || !createsMR(event.tool, event.input)) return
      void reportMRs(event.sessionID, JSON.stringify(event.result)).catch(() => {})
    })

    await ctx.tool.transform((editor) => {
      editor.namespace({ name: "links", description: "Session sidebar links" })
      editor.add({
        name: "report",
        description:
          "Report Linear tickets that this session opened or is working on, so they appear in the sidebar. " +
          "MRs and PRs you create or push to are picked up automatically. " +
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
          const added = (input.tickets ?? []).map((id: string) => id.trim().toUpperCase())
          const next = { tickets: [...new Set([...prev.tickets, ...added])], mrs: prev.mrs }
          await writeReport(context.sessionID, next)
          return { content: `Recorded ${next.tickets.length} ticket(s) for the sidebar.` }
        },
      })
    })
  },
})
