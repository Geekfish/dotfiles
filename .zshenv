# Activate mise when running in Cursor
if [[ -n "$CURSOR_AGENT" ]]; then
  eval "$(mise activate zsh)"
fi
