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
            - [With brew](#with-brew)
        - [Optional](#optional)
    - [Dotfiles](#dotfiles)
        - [Completions](#completions)
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
- 🔑 [LastPass](https://lastpass.com/misc_download2.php)<sup>1</sup>
- ✉️ [Boxysuite](https://www.boxysuite.com/)<sup>1</sup>
- 🦠 [ClamXAV](https://www.clamxav.com/)<sup>1</sup>
- 📦 [Dropbox](https://www.dropbox.com/)
- 🗃 [Google Drive](https://www.google.com/drive/download/)
- 📝 [Notion](https://www.notion.so/desktop)<sup>1</sup>
- 💬 [Slack](https://slack.com/intl/en-de/downloads/mac)
- 📞 [Zoom](https://zoom.us/download)

### Might be needed later

Usually don't need to be install straight away.

- 🧲 [Magnet](https://magnet.crowdcafe.com/)<sup>1</sup>
- 📽 [Deckset](https://www.deckset.com/)<sup>1</sup>
- 📱 [Franz](https://meetfranz.com/)
- 🗝 [Keybase](https://keybase.io/docs/the_app/install_macos)
- 💼 [Office 365](https://www.office.com/)<sup>1</sup>
- ☊ [Mindnode](https://mindnode.com/)<sup>1</sup>
- 🦈 [Surfshark](https://surfshark.com/)<sup>1</sup>

## Concentration

- 🎯[Todoist](https://todoist.com/downloads/mac)<sup>1</sup>
- 🍅 [Pomodone](https://pomodoneapp.com/download-pomodone-app.html)<sup>1</sup>
- 🎧 [Spotify](https://www.spotify.com/de/download/mac/)<sup>1</sup>

## Development

### Must-have

- 💻 [Visual Studio Code](https://code.visualstudio.com/)
  Don't forget to sync settings!
- 📯 [Postman](https://www.postman.com/downloads/)
- 🌐 [Chrome](https://www.google.com/chrome/)
- 📝 [Awesome Vimrc](https://github.com/amix/vimrc)

#### With brew

- Extra casks:
  ```zsh
  brew install --cask \
    java                 `# You *will* eventually need it...`
  ```

- Extra taps:
  ```zsh
  brew tap \
    homebrew/cask-fonts   `# nice fonts`
  ```

- Packages:
  ```zsh
  brew install \
    antigen              `# light-weight alternative to oh-my-zsh` \
    git                  `# latest git version` \
    hub                  `# Github CLI` \
    coreutils            `# GNU core utils (required by asdf)` \
    curl                 `# curl :)` \
    asdf                 `# runtume version manager` \
    the_silver_searcher  `# faster 'ack'` \
    ripgrep              `# even faster 'ack'` \
    diffmerge            `# old-school 3-way merge` \
    diff-so-fancy        `# nicer-looking diffs` \
    fzf                  `# fuzzy finder` \
    jq                   `# 'sed' for JSON` \
    kube-ps1             `# Kubernetes prompt` \
    watch                `# 👀` \
    htop                 `# better 'top'` \
    font-fira-code       `# Beautiful monospaced font with ligatures` \
    neovim               `# smaller, improved version of vim` \
    tree                 `# display directory trees` \
    blackhole-2ch        `# Virtual audio driver` \
    autoconf wxmac gnupg `# For Erlang https://github.com/asdf-vm/asdf-erlang#osx` \
    gpg gpg2 pinentry-mac`# GPG utilities` \
    --cask raycast       `# Spotlight-like omni-helper` \
    --cask flameshot     `# annotated screeshots`


### Optional

Depending on current projects

- 🐘 [Postgres.app](https://postgresapp.com/)
- 🐍 [PyCharm](https://www.jetbrains.com/pycharm/)<sup>1</sup>
- 🐳 [Docker](https://www.docker.com/products/docker-desktop)
- 📜 [Poetry](https://python-poetry.org/docs/#osx--linux--bashonwindows-install-instructions)
- With brew:
  ```zsh
  brew install \
    kubernetes-cli             `# Kubernetes utils` \
    basex                      `# XML database and XPath/XQuery processor` \
    TomAnthony/brews/itermocil `# iTerm-specific teamocil` \
    gmp                        `# Sometimes needed by ruby`

  brew tap shopify/shopify && brew install shopify `# shopify CLI`  
  brew tap heroku/brew && brew install heroku `# Heroku CLI`
  ```

## Dotfiles

Assuming you checkout this repo in your `$HOME` directory, you can run the following to symlink all the dotfiles:

```zsh
cd dotfiles
./install_config.sh
```

⚠️ The above will prompt you about replacing existing dotfiles in case there's something you'd rather keep. The `.git` directory (and any other directory) is ignored.

### Completions

You can install optional completions by running:

```zsh
./install_completions.sh
```

### GPG

To store GPG passphrases in the keychain, you need to run:

```zsh
mkdir -p -m 0700 ~/.gnupg
echo 'pinentry-program /usr/local/bin/pinentry-mac' | tee ~/.gnupg/gpg-agent.conf
pkill -TERM gpg-agent
```

and restart the terminal session.

Next time you're asked for the passphrase, it will be stored in the keychain.

## Fonts

`Fira Code` is a good monospace font for coding that supports [ligatures](https://www.wikiwand.com/en/Ligature_(writing)). It can be installed using `brew` (see above).
Further config might be required depending on the editor, [see here for VSCode](https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions).

---
<sup>1</sup> Requires license/subscription (but might also have a free plan)
