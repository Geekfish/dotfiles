#!/bin/zsh
# Herdr keeps plugin install state itself, so chezmoi only lists the plugins. Runs again when this list changes.
# Plugins run code inside Herdr, so each one is pinned to a reviewed commit. To update one, change its commit here.
# Installing over an existing plugin replaces it and keeps its config.
set -e
type herdr > /dev/null || { echo "herdr not installed, skipping plugins"; exit 0; }
plugins=(
  plannotator/herdr-annotate@99002e24525a9ae327450cd83a17b1e86b2ee81f
  enekos/herdr-quick-actions@e9305cab44b766952ad8aafaa0a69bd3f659e159
  tgdn/herdr-caffeinated@506e80bfece279e34edf4e6c91c21d37996e3ee7
  JanTvrdik/herdr-command-palette@eab940018c2135ac23718efa11e23e9dddcd2a75
)
installed=$(herdr plugin list)
for plugin in $plugins; do
  [[ $installed == *"github:$plugin]"* ]] || herdr plugin install --yes --ref ${plugin#*@} ${plugin%@*}
done
