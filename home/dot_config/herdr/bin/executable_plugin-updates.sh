#!/usr/bin/env bash
# Herdr plugin updates: a once-a-day check, a tab bar hint, and a picker that applies them.
# Herdr has no update command. GitHub plugins are pinned to reviewed commits in the chezmoi
# install script, so an update moves that pin and reinstalls. Linked plugins are git clones,
# so an update is a fast-forward pull.
#
# Usage: plugin-updates.sh status   tab bar text. Reads the cache. Starts a refresh once a day.
#        plugin-updates.sh refresh  check every plugin now
#        plugin-updates.sh pick     choose updates with fzf, then apply them
set -euo pipefail

CACHE=${XDG_CACHE_HOME:-$HOME/.cache}/herdr-plugin-updates
LIST=$CACHE/updates.tsv # kind, name, from, to, where. kind is github or local.
REGISTRY=$HOME/.config/herdr/plugins.json
export GIT_TERMINAL_PROMPT=0 # a fetch that wants a password fails instead of hanging
mkdir -p "$CACHE"

pins() { echo "$(chezmoi source-path)/.chezmoiscripts/run_onchange_after_herdr-plugins.sh"; }

# Writes the list only when every source answered. Otherwise it keeps the old list and
# marks it as checked today, so an offline day neither hides updates nor retries all day.
refresh() {
  local tmp=$LIST.tmp pin repo from to root
  : > "$tmp"
  for pin in $(grep -oE '^\s+[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+@[0-9a-f]{40}' "$(pins)"); do
    repo=${pin%@*} from=${pin#*@}
    to=$(git ls-remote "https://github.com/$repo" HEAD | cut -f1) && [ -n "$to" ] || { touch "$LIST"; return 1; }
    # Only a newer commit counts. A pin off the default branch, or a rewound upstream, is not an update.
    if [ "$to" != "$from" ] && [ "$(gh api "repos/$repo/compare/$from...$to" --jq .status 2>/dev/null || echo ahead)" = ahead ]; then
      printf 'github\t%s\t%s\t%s\t%s\n' "$repo" "$from" "$to" "$repo" >> "$tmp"
    fi
  done
  jq -r '.[] | select(.source.kind == "local") | .plugin_id + "\t" + .plugin_root' "$REGISTRY" |
    while IFS=$'\t' read -r id root; do
      root=$(git -C "$root" rev-parse --show-toplevel 2>/dev/null) || continue
      git -C "$root" fetch -q || { touch "$LIST"; exit 1; }
      from=$(git -C "$root" rev-parse HEAD) to=$(git -C "$root" rev-parse '@{u}' 2>/dev/null) || continue
      # Behind upstream only. A clone with local commits is not an update.
      if [ "$from" != "$to" ] && git -C "$root" merge-base --is-ancestor "$from" "$to"; then
        printf 'local\t%s\t%s\t%s\t%s\n' "$id" "$from" "$to" "$root" >> "$tmp"
      fi
    done
  mv "$tmp" "$LIST"
}

status() {
  # The tab bar runs this every few seconds with a short timeout, so it never waits on the network.
  # A lock older than 10 minutes belongs to a refresh that died.
  find "$CACHE" -maxdepth 1 -name lock -mmin +10 -exec rmdir {} + 2>/dev/null || true
  if [ "$(date -r "$LIST" +%F 2>/dev/null)" != "$(date +%F)" ] && mkdir "$CACHE/lock" 2>/dev/null; then
    (trap 'rmdir "$CACHE/lock"' EXIT; refresh) > /dev/null 2>&1 &
  fi
  local n
  n=$(wc -l < "$LIST" 2>/dev/null | tr -d ' ') || n=0
  [ "${n:-0}" -gt 0 ] && echo "⬆ $n plugin update$([ "$n" -gt 1 ] && echo s) · prefix ⇧U" || true
}

preview() { # one fzf line: kind, name, from, to, where
  IFS=$'\t' read -r kind name from to where <<< "$1"
  if [ "$kind" = local ]; then
    git -C "$where" log --oneline --no-decorate "$from..$to"
  else
    gh api "repos/$name/compare/$from...$to" --jq '.commits[] | .sha[0:7] + " " + (.commit.message | split("\n")[0])' 2>/dev/null ||
      echo "https://github.com/$name/compare/$from...$to"
  fi
}

pick() {
  echo "Checking for updates..."
  refresh || echo "Some sources did not answer. Showing the last known updates."
  if [ ! -s "$LIST" ]; then
    read -rn1 -p "All Herdr plugins are up to date. Press a key to close."
    return
  fi
  local chosen
  chosen=$(fzf --multi --delimiter '\t' --with-nth 2,1 --bind 'ctrl-a:select-all' \
    --header 'tab: select · ctrl-a: all · enter: update' \
    --preview "bash '$0' preview {}" < "$LIST") || return 0
  # The list is on fd 3, so a command that reads stdin cannot eat the remaining choices.
  # One failure is reported and the rest still run. The pin moves only after its install worked.
  local changed=
  while IFS=$'\t' read -r -u3 kind name from to where; do
    echo "Updating $name"
    if [ "$kind" = local ]; then
      git -C "$where" pull -q --ff-only < /dev/null || echo "  FAILED: git pull in $where"
    elif herdr plugin install --yes --ref "$to" "$name" < /dev/null > /dev/null; then
      sed -i '' "s|${name//./\\.}@$from|$name@$to|" "$(pins)" && changed=1
    else
      echo "  FAILED: herdr plugin install $name"
    fi
  done 3<<< "$chosen"
  refresh || echo "Could not recheck for updates."
  [ -n "$changed" ] && echo "Pins changed in $(pins). Commit them in your dotfiles."
  read -rn1 -p "Done. Press a key to close."
}

case "${1:-status}" in
  status) status ;;
  refresh) refresh ;;
  pick) pick ;;
  preview) preview "$2" ;;
  *) echo "usage: $0 status|refresh|pick" >&2; exit 2 ;;
esac
