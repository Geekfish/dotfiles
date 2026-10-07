#!/bin/zsh
# Installs own agent plugins from the marketplace. Runs again when this list changes.
# OpenCode plugins need a separate install process, see the work setup.
set -e
marketplace=Geekfish/agent-plugins
plugins=(herdr-extensions summarizer)

if type claude > /dev/null; then
  claude plugin marketplace list | grep -q "($marketplace)" || claude plugin marketplace add $marketplace
  installed=$(claude plugin list)
  for p in $plugins; do [[ $installed == *"$p@geekfish"* ]] || claude plugin install $p@geekfish; done
fi

if type codex > /dev/null; then
  codex plugin marketplace list | grep -q '^geekfish ' || codex plugin marketplace add $marketplace
  installed=$(codex plugin list)
  for p in $plugins; do grep -q "^$p@geekfish  *installed" <<< $installed || codex plugin add $p@geekfish; done
fi
