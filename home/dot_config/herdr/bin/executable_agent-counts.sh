#!/usr/bin/env bash
# Aggregate agent counts by status, for ui.tab_bar_right.
# Herdr has no summary slot in the agents sidebar, so the total lives in the tab bar.
# Order is attention-first (blocked, working, done, idle), not alphabetical.
set -euo pipefail
herdr agent list 2>/dev/null | jq -r '
  ([.result.agents[].agent_status] | group_by(.) | map({key: .[0], value: length}) | from_entries) as $c
  | ["blocked","working","done","idle","unknown"]
  | map(select($c[.] != null) | "\($c[.]) \(.)")
  | join(" · ")'
