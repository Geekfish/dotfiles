## Communication Style

### Concisesness 
ALWAYS APPLY THIS TO EVERYTHING YOU DO.
When reporting information to me, be extremely concise and sacrifice grammar for the sake of concision.
Follow this rule also for: documentation, code comments, MR descriptions/comments, commits, Slack messages, Notion pages and anything else you write in human language.

### What to document
Documenting the "Why" is always more important than the "What". Only document the "what" if it's very hard to deduct it from the code, like an non-obvious workaround.

When you write text to an external resource (file, commit, Notion page, etc), consider that the reader does not have the context of the agent conversation (and may not care about it).
What they see is the final output. Documentation should be self-contained in its local context (file, thread etc) or use concrete external references (e.g. a link).

### Formatting
Use optimal formatting for easy reading. Use bullets, short sentences. Prefer active voice. Use correct punctuation, but avoid long complicated sentences (e.g. no `;` and `—`). Repeat the sentence subject if it makes things clearer.

Consider "titles" for complex bullet points, e.g `- *Use Titles*: for each bullet point write the "title" part in bolt, unless the point is short enough to not need a title.`
Don't split a bullet point and its explanation into separate same-level bullets. Merge them into one bullet or use nested bullets.

### Terms
Prefer simple language. No metaphors. Use international English, avoid Americanisms and "LLM-speak". E.g. avoid terms like: iff ("if" is enough), smoking gun ("proof"), grandfathering ("backwards compatible" or similar), net diff ("diff" is enough), net new ("new") etc.

## Writing MRs and Docs

- Base MR/PR descriptions on the actual diff vs target, not session rework.
- Avoid mentioning modules, vars, function names in in-code docs (moduledocs, docs etc). If you do always wrap them in `backticks`.
- Docs/comments: explain why, not what. Don't lean on naming functions/modules. Keep them self-contained, no defensive hypotheticals.
- @moduledoc/@doc: The first line should ALWAYS be a short, title-like description. Leave an empty line, then the rest.
- LOCAL docs first: use @doc (public functions) or a code comment (private functions or inline context) to document small business particularities/hacks.
- Human-facing summaries (notes, reports, project pages): no code references (backticks, field names, internal labels). Link every ticket and MR, with its title or a short description of the task as the link text. No bare IDs.
- NEVER post a reply to an MR/PR comment without my explicit approval. Applies to bot threads (Bugbot etc) too. Draft the reply, show it to me, wait. Same for resolving threads.
- Sign every MR/PR comment I approve for posting with this footer, on its own lines at the end:
  ```
  -----
  Written by Claude on behalf of Eleni Lixourioti
  ```

## MCP Connectivity

A server listed as "still connecting" (not absent, not "requires authentication") is mid-handshake. If a call to it comes up empty, wait ~10s and retry up to 2 more times before calling it unavailable.

## Shell Environment

- `cd` is aliased to zoxide's `z`. Use `builtin cd` when you need the real one. Never `builtin mix` — `mix` isn't a shell builtin.
- `rtk history.db` is the source of truth for rtk-proxied commands. Query it, don't mine transcripts.
