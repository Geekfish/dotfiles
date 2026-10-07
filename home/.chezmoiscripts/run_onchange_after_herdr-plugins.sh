#!/bin/zsh
# Herdr keeps plugin install state itself, so chezmoi only lists the plugins. Runs again when this list changes.
set -e
type herdr > /dev/null || { echo "herdr not installed, skipping plugins"; exit 0; }
installed=$(herdr plugin list)
for repo in plannotator/herdr-annotate enekos/herdr-quick-actions tgdn/herdr-caffeinated JanTvrdik/herdr-command-palette; do
  [[ $installed == *"github:$repo@"* ]] || herdr plugin install --yes $repo
done
