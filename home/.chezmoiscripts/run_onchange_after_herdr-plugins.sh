#!/bin/zsh
# Herdr keeps plugin install state itself, so chezmoi only lists the plugins. Runs again when this list changes.
# Plugins run code inside Herdr, so each third-party one is pinned to a reviewed commit. To update one, change its commit here.
# My own plugins have no pin and install their latest commit.
# Installing over an existing plugin replaces it and keeps its config.
set -e
type herdr > /dev/null || { echo "herdr not installed, skipping plugins"; exit 0; }
plugins=(
  plannotator/herdr-annotate@c5e565e9bdbb52d152ad15169f38ed8bae31b610
  enekos/herdr-quick-actions@e9305cab44b766952ad8aafaa0a69bd3f659e159
  tgdn/herdr-caffeinated@506e80bfece279e34edf4e6c91c21d37996e3ee7
  JanTvrdik/herdr-command-palette@eab940018c2135ac23718efa11e23e9dddcd2a75
  senna-lang/herdr-agent-usage@592e277bfe8963c64eeedc137e94bbfce05069f9
  Geekfish/herdr-keep-awake
)
installed=$(herdr plugin list)
for plugin in $plugins; do
  if [[ $plugin == *@* ]]; then
    [[ $installed == *"github:$plugin]"* ]] || herdr plugin install --yes --ref ${plugin#*@} ${plugin%@*}
  else
    [[ $installed == *"github:$plugin@"* ]] || herdr plugin install --yes $plugin
  fi
done
