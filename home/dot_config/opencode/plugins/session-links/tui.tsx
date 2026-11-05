import { homedir } from "node:os"
import { join } from "node:path"
import { readFile } from "node:fs/promises"
import { Plugin } from "@opencode/plugin/tui"

type Ref = { key: string; url: string }

// Written by the server part's links_report tool.
const reportPath = (sessionID: string) =>
  join(homedir(), ".local", "state", "opencode", "session-links", `${sessionID}.json`)

const mrKey = (url: string) => `!${url.match(/\/(?:merge_requests|pull)\/(\d+)/)?.[1] ?? url}`

export default Plugin.define({
  id: "local.session-links.tui",
  setup(context) {
    const [store, setStore] = context.storage.memory("refs", {
      initial: { tickets: [] as Ref[], mrs: [] as Ref[] },
    })
    let lastSessionID: string | undefined
    let debounce: ReturnType<typeof setTimeout> | undefined

    async function refresh(sessionID: string) {
      let report: { tickets?: string[]; mrs?: string[] }
      try {
        report = JSON.parse(await readFile(reportPath(sessionID), "utf8"))
      } catch {
        return
      }
      const tickets = [...new Set(report.tickets ?? [])].map((id) => ({
        key: id.toUpperCase(),
        url: `https://linear.app/issue/${id.toUpperCase()}`,
      }))
      const mrs = [...new Set(report.mrs ?? [])].map((url) => ({ key: mrKey(url), url }))
      setStore((draft) => {
        draft.tickets = tickets
        draft.mrs = mrs
      })
    }

    const schedule = () => {
      if (!lastSessionID) return
      clearTimeout(debounce)
      debounce = setTimeout(() => lastSessionID && refresh(lastSessionID), 1000)
    }

    const stopListen = context.data.listen(({ details }) => {
      if (!details || typeof details.type !== "string" || !details.type.includes("message")) return
      schedule()
    })
    const poll = setInterval(schedule, 10_000)

    const unregister = context.ui.slot({
      append: "sidebar.content",
      render: (props) => {
        if (props.sessionID && props.sessionID !== lastSessionID) {
          lastSessionID = props.sessionID
          void refresh(props.sessionID)
        }
        const { tickets, mrs } = store
        if (tickets.length === 0 && mrs.length === 0) return null
        return (
          <box marginBottom={1} flexShrink={0}>
            {tickets.length > 0 && (
              <box flexShrink={0}>
                <text fg={context.theme.text.base}>
                  <b>Tickets</b>
                </text>
                {tickets.map((t) => (
                  <text fg={context.theme.text.base}>
                    {"• "}
                    <a href={t.url}>{t.key}</a>
                  </text>
                ))}
              </box>
            )}
            {mrs.length > 0 && (
              <box marginTop={tickets.length > 0 ? 1 : 0} flexShrink={0}>
                <text fg={context.theme.text.base}>
                  <b>Merge Requests</b>
                </text>
                {mrs.map((m) => (
                  <text fg={context.theme.text.base}>
                    {"• "}
                    <a href={m.url}>{m.key}</a>
                  </text>
                ))}
              </box>
            )}
          </box>
        )
      },
    })

    return () => {
      stopListen()
      clearInterval(poll)
      clearTimeout(debounce)
      unregister()
    }
  },
})
