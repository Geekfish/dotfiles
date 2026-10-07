# Dotfiles & New Laptop Setup

## Table of Contents

<!-- TOC -->

- [Dotfiles & New Laptop Setup](#dotfiles--new-laptop-setup)
    - [Table of Contents](#table-of-contents)
    - [About](#about)
    - [General](#general)
        - [Essentials](#essentials)
        - [Might be needed later](#might-be-needed-later)
    - [Dotfiles](#dotfiles)
        - [New machine](#new-machine)
        - [Machine with the old symlinked dotfiles](#machine-with-the-old-symlinked-dotfiles)
        - [Everyday use](#everyday-use)
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
- 🐏 [Herdr](https://herdr.dev/)
- 🔑 [1password](https://1password.com/)<sup>1</sup>
- 🗃 [Google Drive](https://www.google.com/drive/download/)
- 📝 [Obsidian](https://obsidian.md/)

### Might be needed later

Usually don't need to be install straight away.

- 🖥️ [Flameshot](https://flameshot.org/)
- 🥞 [TablePlus](https://tableplus.com/)
- 💬 [Signal](https://signal.org/)
- 📽 [Deckset](https://www.deckset.com/)<sup>1</sup>
- 🗝 [Keybase](https://keybase.io/docs/the_app/install_macos)
- 💼 [Office 365](https://www.office.com/)<sup>1</sup>
- 🎧 [Spotify](https://www.spotify.com/de/download/mac/)<sup>1</sup>
- 💻 [Visual Studio Code](https://code.visualstudio.com/)
  Don't forget to sync settings!

## Dotfiles

The dotfiles are managed with [chezmoi](https://www.chezmoi.io/). The repo lives in `~/dotfiles`. Files under `home/` map to `$HOME`.

On the first run, chezmoi asks:

- if this is a work machine
- your name, emails and PGP signing key IDs for git

The answers stay in `~/.config/chezmoi/chezmoi.toml` on that machine. They are never committed. Signing key IDs refer to public PGP keys.

Work machines also pull a private repo with work-only files. It needs an SSH key with access to that repo.

### New machine

1. Install [Brew](https://brew.sh/), then chezmoi:

```zsh
brew install chezmoi
```

2. Clone and apply. Answer the prompts.

```zsh
chezmoi init --apply --source ~/dotfiles Geekfish/dotfiles
```

### Machine with the old symlinked dotfiles

The old setup linked files from `~/dotfiles` into `$HOME`. chezmoi copies them instead.

1. Install chezmoi and update the repo. Some old links point to moved files and break until step 3.

```zsh
brew install chezmoi
cd ~/dotfiles && git pull
```

2. Create the machine config. Answer the prompts with the values from `~/.gitconfig_personal` and `~/.gitconfig_work`.

```zsh
chezmoi init --source ~/dotfiles
```

3. Review, then replace the old links with real files:

```zsh
chezmoi diff
chezmoi apply
```

4. Delete `~/.gitconfig_personal` and `~/.gitconfig_work`. chezmoi now writes these values.

### Everyday use

- Edit a file: `chezmoi edit ~/.zshrc`, or edit it under `~/dotfiles/home/` and run `chezmoi apply`.
- Pick up a change made directly in `$HOME`: `chezmoi re-add`.
- Pull and apply changes from another machine: `chezmoi update`.

#### Brew packages

Brew packages, casks and VS Code plugins live in `Brewfile`.

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

3. chezmoi sets the key and author details from the answers to its prompts.

## Fonts

`Fira Code` is a good monospace font for coding that supports [ligatures](https://www.wikiwand.com/en/Ligature_(writing)). It can be installed using `brew` (see above).
Further config might be required depending on the editor, [see here for VSCode](https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions).

---
<sup>1</sup> Requires license/subscription (but might also have a free plan)
