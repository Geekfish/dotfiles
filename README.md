# Dotfiles & New Laptop Setup

## Table of Contents

<!-- TOC -->

- [Dotfiles & New Laptop Setup](#dotfiles--new-laptop-setup)
    - [Table of Contents](#table-of-contents)
    - [About](#about)
    - [General](#general)
        - [Essentials](#essentials)
        - [Might be needed later](#might-be-needed-later)
    - [Concentration](#concentration)
    - [Development](#development)
        - [Must-have](#must-have)
    - [Nix - Experimental](#nix---experimental)
    - [Dotfiles](#dotfiles)
            - [Brew packages](#brew-packages)
        - [Completions](#completions)
        - [GPG](#gpg)
    - [Fonts](#fonts)

<!-- /TOC -->
## About

This is just my personal guide for keeping track of my configurations and facilitate setting up a new machine.

The TOC in this document is built with the [Auto Markdown TOC](https://marketplace.visualstudio.com/items?itemName=huntertran.auto-markdown-toc) VS Code extension.

## General

Before installing the dotfiles it may be a good idea to install some of the things below.

### Essentials

- ⌨️ [iTerm2](https://www.iterm2.com/)
- 🍺 [Brew](https://brew.sh/)
- 🦊 [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- 🔑 [1password](https://1password.com/)<sup>1</sup>
- 🗃 [Google Drive](https://www.google.com/drive/download/)
- 📝 [Obsidian](https://obsidian.md/)

### Might be needed later

Usually don't need to be install straight away.

- 🥞 [TablePlus](https://tableplus.com/)
- 💬 [Signal](https://signal.org/)
- 📽 [Deckset](https://www.deckset.com/)<sup>1</sup>
- 🗝 [Keybase](https://keybase.io/docs/the_app/install_macos)
- 💼 [Office 365](https://www.office.com/)<sup>1</sup>

## Concentration

- ☊ [Mindnode](https://mindnode.com/)<sup>1</sup>
- 🎧 [Spotify](https://www.spotify.com/de/download/mac/)<sup>1</sup>

## Development

### Must-have

- 💻 [Visual Studio Code](https://code.visualstudio.com/)
  Don't forget to sync settings!
- 📯 [Postman](https://www.postman.com/downloads/)
- 🌐 [Chrome](https://www.google.com/chrome/)
- 📝 [Awesome Vimrc](https://github.com/amix/vimrc)

## Nix - Experimental

To install:

```zsh
<(curl -L https://nixos.org/nix/install)

nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

## Dotfiles

Assuming you checkout this repo in your `$HOME` directory, you can run the following to symlink all the dotfiles:

```zsh
cd dotfiles
./install_config.sh
```

⚠️ The above will prompt you about replacing existing dotfiles in case there's something you'd rather keep. The `.git` directory (and any other directory) is ignored.

#### Brew packages

Brew packages, casks and vscode plugins live in `Brewfile`.

You can install them with

```zsh
brew bundle --global
```

### Completions

You can install optional completions by running:

```zsh
./install_completions.sh
```

### GPG

1. To store GPG passphrases in the keychain, you need to run:

```zsh
mkdir -p -m 0700 ~/.gnupg
echo "pinentry-program $(which pinentry-mac)" | tee ~/.gnupg/gpg-agent.conf
pkill -TERM gpg-agent
```

and restart the terminal session.

Next time you're asked for the passphrase, it will be stored in the keychain.

2. Make sure you import a valid GPG key, see also [GPG, Github and Keybase guide](https://github.com/pstadler/keybase-gpg-github).

3. Ensure the key and author details are actually used, by setting up `.gitconfig_personal` (not shared here)

```
[user]
  name = "..."
  email = "..."
  signingkey = "..."

```

## Fonts

`Fira Code` is a good monospace font for coding that supports [ligatures](https://www.wikiwand.com/en/Ligature_(writing)). It can be installed using `brew` (see above).
Further config might be required depending on the editor, [see here for VSCode](https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions).

---
<sup>1</sup> Requires license/subscription (but might also have a free plan)
