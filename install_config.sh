#!/bin/zsh

# Link all the user-dir dotfiles
ln -si "$(pwd)"/.*(.) "$HOME"

# Create .config dir if it doesn't exist
mkdir -p "$HOME/.config"

ln -siF "$(pwd)"/.config/* "$HOME/.config"
