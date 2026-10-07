# OpenCode

Use this file only when the selected kind is `opencode`. It launches with `herdr agent start` like the other kinds in step 7.

## Model and effort

Resolve both a model and reasoning effort before creating the work tab. Use values already supplied by the user. Otherwise ask for the missing value. Accept any full model ID returned by `opencode models`. These shorthands are conveniences, not an allowlist:

| Shorthand | Model ID |
|---|---|
| `luna` | `openai/gpt-5.6-luna` |
| `sol` | `openai/gpt-5.6-sol` |
| `terra` | `openai/gpt-5.6-terra` |
| `astra` | `openai/gpt-6-astra` |

Reasoning efforts commonly include `none`, `minimal`, `low`, `medium`, `high`, and `xhigh`. The selected model decides which ones are available. For example, "OpenCode sol xhigh" means model `openai/gpt-5.6-sol` with `xhigh` effort.

## Launch

Arguments after `--`:

```
--model <MODEL_ID> --auto
```

`--auto` routes OpenCode approval requests through automatic review. Explicit permission denials still apply.

The pane is ready when it shows the OpenCode input box with its model in the footer.

## Set the effort

OpenCode represents reasoning effort internally as a model variant, but has no TUI startup flag for it. After it is ready, read the pane and check the effort shown beside the model. If it is not the requested effort, cycle efforts with OpenCode's `variant_cycle` key and read the pane after each keypress:

```bash
herdr agent send-keys <AGENT_NAME> ctrl+t
herdr pane read <PANE_ID> | tail -15
```

Stop when the requested effort is visible. Stop after one full cycle if it is unavailable, report the efforts observed, and ask the user to choose one. Do not send the task prompt until the requested effort is visible.

## Example

OpenCode with Sol and xhigh effort. Repeat `ctrl+t` until `xhigh` is visible:

```bash
herdr agent start abc123profilepostcodedropped --kind opencode --pane pane-123 --timeout 60000 -- --model openai/gpt-5.6-sol --auto
herdr agent send-keys abc123profilepostcodedropped ctrl+t
herdr pane read pane-123 | tail -15
herdr agent prompt abc123profilepostcodedropped "Work on https://linear.app/acme/issue/ABC-123. Start by reading the ticket, then investigate in this workspace."
```
