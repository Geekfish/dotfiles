#!/bin/zsh

# Link all the user-dir dotfiles
ln -siF .*(.) "$HOME"

# Create .config dir if it doesn't exist
mkdir -p "$HOME/.config"

ln -siF .config/* "$HOME/.config"
