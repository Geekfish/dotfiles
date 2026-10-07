---
name: herdr-new-task
description: Start a Herdr tab with an agent primed on a task. Use when a user asks to start a new tab or task for a prompt, issue, or thread, optionally naming a workspace, agent, model, or reasoning effort.
allowed-tools: Read, Bash(herdr:*), Bash(jq:*), Bash(cp:*), Bash(test:*), Bash(gh issue:*), Bash(gh repo view:*), mcp__Linear__get_issue, mcp__Linear__list_teams, mcp__Linear__save_issue, mcp__claude_ai_Slack__slack_read_thread
---

# Herdr New Task

Set up a Herdr tab in the right workspace with an agent already primed on the task.

## Preconditions

```bash
test "${HERDR_ENV:-}" = 1
```

If this fails, say you are not running inside Herdr and stop.

## Workspaces come from `~/my-workspace.toml`

The skill holds no workspace list. Read `~/my-workspace.toml`. It has one `[[workspace]]` block per Herdr workspace:

| Field | Meaning |
|---|---|
| `label` | Herdr workspace label. Match workspaces by label, not by cwd. Several workspaces can share a cwd. |
| `cwd` | Directory for new tabs. Expand a leading `~` to `$HOME` before passing it to `herdr`. |
| `description` | What the workspace is for. Step 2 infers the workspace from it. |
| `named_only` | Optional. `true` means use it only when the user says its label. |
| `prompt_suffix` | Optional. Append this sentence to the agent prompt in step 7. |
| `tracker` | Optional. `linear`, `github` (the repo of `cwd`), or `github:<owner>/<repo>`. A top-level `tracker` key above the first block sets the default. If neither is set and a step needs it, ask the user. |

If the file does not exist, stop and tell the user. Offer to copy `references/my-workspace.toml.example` (next to this SKILL.md) to `~/my-workspace.toml`. After they agree, copy it, tell them to edit it later, and continue with its contents.

If the user names a workspace that is not in the file, ask for its cwd and description, then append a `[[workspace]]` block to `~/my-workspace.toml` before continuing.

## Step 1 — Resolve the task

A ticket is an issue in a tracker. The skill supports these trackers:

| Tracker | Recognise it by | Read | Assign to me | Create |
|---|---|---|---|---|
| `linear` | a `linear.app/<org>/issue/<TEAM>-<N>` URL, or a bare `<TEAM>-<N>` id | Linear MCP `get_issue` | Linear MCP `save_issue` with `assignee: "me"` | Linear MCP `save_issue` with `assignee: "me"`. Ask for the team, using `list_teams` when you need the list. |
| `github` | a `github.com/<owner>/<repo>/issues/<N>` URL, or `<owner>/<repo>#<N>` | `gh issue view <N> --repo <owner>/<repo>` | `gh issue edit <N> --repo <owner>/<repo> --add-assignee @me` | `gh issue create --repo <owner>/<repo> --assignee @me` |

A URL names its own tracker. A bare id like `ABC-123` or `#42` does not. Use the `tracker` of the workspace, picking the workspace first (step 2) when needed. For a bare id, pick the workspace from the user's words only, because the ticket is not read yet. For plain `github`, get the repo with `gh repo view --json nameWithOwner` run in that `cwd`. If that fails, ask the user for `<owner>/<repo>`.

**Chat thread URL** (for example a Slack thread): read the thread with the chat tool you have. Scan its text, attachments and link previews for a ticket URL or id. Take the first one and read it.

**No ticket found** (thread without a link, or the user described the work in prose): go to step 1a.

Keep every URL you resolved. The prompt in step 7 uses all of them.

### Step 1a — Offer to create a ticket

Ask the user whether to create a ticket. Do this whenever there is no ticket, including a plain idea with no thread.

If yes:

1. Pick the workspace (step 2) and take its tracker. For Linear, ask which team, or confirm one you infer from the workspace.
2. Draft the title and description. Show the draft. **Wait for approval.** Never create the ticket without it.
3. Create it, assigned to the user, and use the new identifier from here on.

If no: continue with no ticket. The label in step 3 is then slug only.

### Step 1b — Claim an unassigned ticket

A ticket with no assignee gets assigned to the user, without asking. Leave an existing assignee alone, even when it is someone else. Say so in the final report instead.

## Step 2 — Pick the workspace

If the user named a workspace, use it. Otherwise pick the workspace whose `description` fits the task best, skipping any with `named_only = true`, and say which one you picked in the final report.

Typical signals: the ticket's team or repo, technology or project names the description mentions, a path under a project the description names, whether the task is a customer report or incident versus a planned change, whether there is a ticket at all.

If two descriptions fit equally, or none does, ask the user. Do not guess between two on a coin flip.

### Step 2a — Select the agent

Agent kind is `claude` unless the user asked for another one.

For `claude` or `codex`, pass a model or reasoning effort when the user supplies one. Otherwise let that CLI use its configured defaults.

A kind can have a harness file named `<kind>.md`. Look for it in `references/harnesses/` next to this SKILL.md, then in `~/.config/herdr-new-task/harnesses/`, which holds machine-specific harnesses. Use the first one found. The kind follows that file for its options, launch, checks and report lines. Where that file differs from this skill, the file wins. Read it now, before creating the work tab. A kind that is not in the step 7 list and has no such file is not supported: say so and stop.

## Step 3 — Build the label

With a ticket:

```
<TICKET-ID>-<3-to-4-word-slug>
```

For a GitHub issue, the ticket id is `<repo>-<N>`, for example `dotfiles-42`.

Without a ticket:

```
<3-to-4-word-slug>
```

The slug comes from the ticket title or the user's description: lowercase, hyphen separated, only the words that identify the problem.

| Input | Label |
|---|---|
| ABC-123 "Saving the profile form drops the postcode field" | `ABC-123-profile-postcode-dropped` |
| `acme/shop#42` "Checkout total ignores discount code" | `shop-42-checkout-discount-total` |
| "look into why the nightly export writes duplicate rows" | `export-duplicate-rows` |

## Step 4 — Find or create the workspace

```bash
herdr workspace list | jq -r '.result.workspaces[] | .workspace_id + " " + .label'
```

Match the target label case-insensitively. If more than one matches, use the first and mention it in the final report.

No match — create it with the `cwd` from `~/my-workspace.toml`:

```bash
herdr workspace create --label "<LABEL>" --cwd "<CWD>" --no-focus
```

The new workspace id is at `.result.workspace.workspace_id`. `workspace create` also creates a first tab, with its id at `.result.tab.tab_id`. Rename that tab into the Term tab rather than creating another:

```bash
herdr tab rename <new-tab-id> "Term"
```

## Step 5 — Ensure a "Term" tab exists

```bash
herdr tab list --workspace <WS_ID> | jq -r '.result.tabs[] | .tab_id + " " + .label'
```

If no label matches `^Term$` (case-insensitive), create one and leave it empty. Never start an agent in it.

```bash
herdr tab create --workspace <WS_ID> --cwd "<CWD>" --label "Term" --no-focus
```

## Step 6 — Check for a duplicate, then create the work tab

The tab list from step 5 also answers this. If any label contains the ticket id, or the slug when there is no ticket, a tab for this task already exists. Report it and ask whether to reuse it or create a second one. Do not silently create a duplicate.

```bash
herdr tab create --workspace <WS_ID> --cwd "<CWD>" --label "<LABEL>" --no-focus
```

The pane id is at `.result.root_pane.pane_id`.

## Step 7 — Start the agent and prompt it

`herdr agent start` launches these kinds: `pi`, `claude`, `codex`, `gemini`, `cursor`, `devin`, `agy`, `cline`, `omp`, `mastracode`, `opencode`, `copilot`, `kimi`, `kiro`, `droid`, `amp`, `grok`, `hermes`, `kilo`, `qodercli`, `qwen`, `maki`.

Agent name: the label with every non-alphanumeric character removed, lowercased, cut to 32 characters — `ABC-123-profile-postcode-dropped` becomes `abc123profilepostcodedropped`. It must match `[a-z][a-z0-9_-]{0,31}` and be unique among live agents (`herdr agent list`). If taken, append `-2`.

### Build the prompt

Build the prompt before you launch anything, because some kinds take it at launch. Build it from what you resolved:

- Ticket: `Work on <TICKET_URL> . Start by reading the ticket, then investigate in this workspace.`
- Chat thread as well: add `Reported in this thread: <THREAD_URL>` before the "Start by reading" sentence.
- No ticket: `<the user's description, in full> . Start by orienting yourself in this workspace.`
- If the workspace has a `prompt_suffix`, end with it.
- If the task is to explain a failure, error or incident rather than make a planned change, and the suffix did not already say so, end with: `Do not change code until you have reported your diagnosis.`

### Launch

```bash
herdr agent start <AGENT_NAME> --kind <KIND> --pane <PANE_ID> --timeout 60000 [-- <AGENT_ARGS>...]
```

Use kind-specific arguments:

| Kind | Arguments after `--` |
|---|---|
| `claude` | `--model <MODEL> --effort <EFFORT> --permission-mode auto` |
| `codex` | `--model <MODEL> --config model_reasoning_effort=<EFFORT> --approve-for-me` |

Omit `--model` and the effort argument for Claude or Codex when the user did not select them. Other kinds take their own flags, so pass none unless the user asked for some.

### Launch and prompt example

Claude with Opus and high effort:

```bash
herdr agent start abc123profilepostcodedropped --kind claude --pane pane-123 --timeout 60000 -- --model opus --effort high --permission-mode auto
herdr agent prompt abc123profilepostcodedropped "Work on https://linear.app/acme/issue/ABC-123. Start by reading the ticket, then investigate in this workspace."
```

Perform the readiness checks before sending the prompt.

### Make sure that the agent is really running

A launch command does not confirm that the agent survived. `herdr agent start` reports success as soon as it sends the launch command. A CLI that auto-updates on launch prints its release notes, tells you to restart it, and exits. A prompt sent to that pane goes to the shell and is lost.

Check the pane after every launch:

```bash
herdr pane read <PANE_ID> | tail -20
herdr agent list | jq -c '.result.agents[] | select(.pane_id=="<PANE_ID>")'
```

The agent is running when both are true:

- the pane shows the agent's own input box, per the table below; and
- `herdr agent list` has a row for that pane id.

| Kind | What the pane shows when it is ready |
|---|---|
| `claude` | the Claude Code prompt box |
| `codex` | `Ask Codex to do anything` |

If the pane shows a shell prompt, an update notice, a crash, or a login request, or the pane has no row in `herdr agent list`, the agent is not running. Launch it again with the same pane, then check again. An auto-update needs one restart and then works. Stop after two failed attempts and report what the pane shows, because a login or a missing binary needs the user.

Ignore an MCP server that failed to start. The agent still runs. Mention it in the final report.

### Send the prompt

Skip this for a kind whose harness file passes the prompt at launch.

```bash
herdr agent prompt <AGENT_NAME> "<PROMPT>"
```

Send it without `--wait`. This skill sets work up, it does not wait for the result.

Then read the pane once more to confirm that the agent received the text:

```bash
herdr pane read <PANE_ID> | tail -15
```

The prompt text must appear in the agent's transcript, above a working or thinking indicator. If the pane shows the prompt text next to a shell prompt instead, the agent is not running. Go back to the check above.

## Step 8 — Report back

Output exactly these lines and nothing else. No preamble, no ticket summary, no next steps.

```
- Workspace "<workspace label>" (<workspace id>) created
- Tab "Term" created
- Tab "<tab label>" created
- Agent <agent name> (<kind>) prompted with <the full prompt text you sent>
- Agent <agent name> (<kind>, <model> <effort>) prompted with <the full prompt text you sent>
- Ticket <TICKET-ID> assigned to you
```

Use only the applicable agent line. Include the model and effort when selected. Say `created` for a workspace this skill created, `updated` for one that already existed. Include the `Tab "Term"` line only when this skill created or renamed that tab. Include the ticket line only when this skill changed the assignee, and replace it with `- Ticket <TICKET-ID> already assigned to <name>` when someone else holds it. Add one line naming the workspace you inferred when the user did not name one. Add one line when the agent needed a restart, or when an MCP server failed to start in its pane. A kind's harness file can add report lines of its own.

## Notes

- Always `--no-focus`. The user stays where they are unless they ask to switch.
- The cwd is the `cwd` from `~/my-workspace.toml`, never a project inside it. Tasks often span several projects.
- Do not close or rename tabs you did not create.
- `--permission-mode auto` stops a Claude agent stalling on permission prompts in a tab nobody is watching.
- `--approve-for-me` routes Codex approval requests through automatic review.
