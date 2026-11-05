import { Plugin } from "@opencode/plugin/tui"

const pad = (n: number) => String(n).padStart(2, "0")
const format = (ms: number) => {
  const d = new Date(ms)
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`
}

export default Plugin.define({
  id: "local.session-id",
  setup(context) {
    return context.ui.slot({
      prepend: "sidebar.content",
      render: (props) => {
        // Only user and assistant turns count. Other entries (idle, model switches etc) are not messages a person reads.
        let latest = 0
        for (const m of context.data.session.message.list(props.sessionID)) {
          if (m.type !== "user" && m.type !== "assistant") continue
          latest = Math.max(latest, m.type === "assistant" ? (m.time.completed ?? m.time.created) : m.time.created)
        }
        return (
          <box marginBottom={1} flexShrink={0}>
            <text fg={context.theme.text.base}>
              <b>Session</b>
            </text>
            <text fg={context.theme.text.base}>ID: {props.sessionID}</text>
            {latest > 0 && <text fg={context.theme.text.base}>Last msg: {format(latest)}</text>}
          </box>
        )
      },
    })
  },
})
