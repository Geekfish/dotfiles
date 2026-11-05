import { Plugin } from "@opencode/plugin/tui"

export default Plugin.define({
  id: "local.session-id",
  setup(context) {
    return context.ui.slot({
      prepend: "sidebar.content",
      render: (props) => (
        <box marginBottom={1} flexShrink={0}>
          <text fg={context.theme.text.base}>
            <b>Session ID</b>
          </text>
          <text fg={context.theme.text.base}>{props.sessionID}</text>
        </box>
      ),
    })
  },
})
