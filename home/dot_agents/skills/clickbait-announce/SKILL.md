---
name: clickbait-announce
description: Use when the user wants a Slack announcement, team update, or hype post about shipped work written like a YouTube clickbait title and thumbnail, with heavy emoji. Triggers include "clickbait announcement", "YouTube-style announcement", "hype up my work on X", "announce X like a YouTuber", "/clickbait-announce".
---

# Clickbait Announce

Turn real shipped work into a Slack post shaped like a YouTube title plus thumbnail. Loud outside, true inside. Output is text in the reply for the user to paste. Never posts to Slack.

## 1. Collect facts

Resolve the subject named in the request:

- Repo paths: `git log --oneline --since="3 weeks ago" --author="$(git config user.name)"` plus the README intro.
- Ticket IDs (Linear, GitHub) or MR URLs: title and description.
- Free text: use as given.

Write down 3 to 5 facts. Each traces to a commit, a doc line, or a user statement. Unmerged pushed work carries a "landing soon" tag. Uncommitted changes are not facts. Nothing else appears as a claim. Jokes are fine when unmistakable as jokes.

## 2. Harvest workspace emoji

If a Slack MCP with custom emoji search is available, run two searches, each with at most 6 comma-separated terms so the 200-hit cap does not truncate results. First: subject words (repo names, languages, tools). Second: `party,hype,mind,fire,eyes,ship`. Pick 8 to 12 hits that fit the facts.

- Custom emoji: only names the search returned, written as `:name:`. Standard Unicode shortcodes such as `:eyes:` are always valid and need no search.
- Custom emoji go in the body and CTA. Unicode goes in the title so it reads outside Slack.
- No Slack MCP: Unicode only. Say so in one line under the output.

## 3. Compose

Budget: 120 to 180 words, excluding links and code. It is an intro, not a changelog. Cut facts before cutting hype. Fixed shape, this order:

1. **Title**, one line. One hook device from the table. 1 to 3 words in ALL CAPS. 2 to 4 Unicode emoji. Ends with one tag from the tag table.
2. **Thumbnail**, one line. 3 to 6 words in caps, opened by one thumbnail pointer: `🔴➡️`, `👉`, `🫵`, `⭕👀`, `⬇️😱`. Vary it across posts. Not `🚩`, that reads as a warning.
3. **Body**, 3 to 5 bullets. Each bullet is two lines: `• :emoji: *Bold title in clickbait phrasing* :emoji:` then the fact in one sentence on the next line. Slack bold is single asterisks. The fact carries one concrete detail: a command, a file, a number. At most one inline code span per bullet.
4. **CTA**, 1 to 2 lines. Creator sign-off ("SMASH that :eyes:", "link in bio 👇"), then each real link on its own line.

| Hook device | Shape |
|---|---|
| Curiosity gap | "...and what happened next" |
| Number bait | "5 COMMANDS that..." |
| Before/after | "Day 1 vs Day 30" |
| Forbidden knowledge | "the ONE flag they don't want you to know" |
| Reaction | "I tried X for a week" |
| Versus | "X vs Y (who wins?)" |

| Tag signal | Tags |
|---|---|
| Truth claim | `(NOT CLICKBAIT)`, `(100% REAL)`, `(PROOF)`, `(NO CAP)` |
| Outcome | `(GONE WRONG)`, `(GONE RIGHT)`, `(IT ACTUALLY WORKED)`, `(SHOCKING RESULTS)`, `(IT'S NOT WHAT YOU THINK)` |
| Tone | `(EMOTIONAL)`, `(MUST WATCH)`, `(WHOLESOME)` |
| Time pressure | `(24 HOUR CHALLENGE)`, `(FINALLY)`, `(LAST CHANCE)` |
| Dev twist | `(NO REWRITE)`, `(ZERO DOWNTIME)`, `(IN PROD)`, `(FIRST TRY)` |

Layout: one blank line between title, thumbnail, every bullet, and the CTA. Never two bullets touching. Airy beats dense.

`--calm` flag: same shape, one emoji per line, ALL CAPS only in the title.

## 4. Check before replying

- Every bullet maps to a step 1 fact.
- Every custom `:name:` came from the step 2 result.
- Links point at the repos or MRs actually read.
- No `@channel`, no `@here`, no named person as the punchline.
- Word count inside budget.

## Example

```
🚨🦀 I REWROTE MY DOTFILES AND MY LAPTOP WILL NEVER BE THE SAME 😱 (NOT CLICKBAIT)

🔴➡️ ONE COMMAND. EVERY MACHINE. 👀

• :rocket: *NO MORE SYMLINK SPAGHETTI* :exploding_head:
`chezmoi apply` writes real files instead of 20 hand-made links.

• :lock: *THE SECRET THAT NEVER LEAVES YOUR LAPTOP* :eyes:
Emails and signing keys are asked once per machine and never committed.

• :fire: *THE INSTALL SCRIPT IS DEAD* :100:
A new machine runs one `chezmoi init`. Migration guide in the README.

SMASH that :eyes: and drop bugs in the thread 🧵👇
https://github.com/example/dotfiles
```

## Common mistakes

- **Changelog in disguise.** Ten bullets, 400 words. The budget exists for this.
- **Guessed shortcodes.** `:partyparrot:` may not exist in this workspace. Search first.
- **Hype without a hook.** "Big update!" is not a title. Pick a device from the table.
