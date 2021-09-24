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
    - [Installing Erlang](#installing-erlang)
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
- 🎩 [Alfred](https://www.alfredapp.com/)<sup>1</sup>
- 👓 [Adobe Reader](https://get.adobe.com/uk/reader/)
- 📽 [Deckset](https://www.deckset.com/)<sup>1</sup>
- 📱 [Franz](https://meetfranz.com/)
- ⏺ [Gifox](https://gifox.io/) (v1)<sup>1</sup>
- 🗝 [Keybase](https://keybase.io/docs/the_app/install_macos)
- 💼 [Office 365](https://www.office.com/)<sup>1</sup>
- ☊ [Mindnode](https://mindnode.com/)<sup>1</sup>
- 📸 [Skitch](https://evernote.com/products/skitch)
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
- 📑 [Dash](https://kapeli.com/dash)<sup>1</sup>
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
    homebrew/cask-fonts   `# nice fonts` \
    shopify/shopify       `# shopify CLO`
  ```
  
- Packages:
  ```zsh
  brew install \
    antigen              `# light-weight alternative to oh-my-zsh` \
    git                  `# latest git version` \
    hub                  `# Github CLI` \
    coreutils            `# GNU core utils (required by asdf)` \
    gmp                  `# Sometimes needed by ruby` \
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
    itermocil            `# iTerm-specific teamocil` \
    font-fira-code       `# Beautiful monospaced font with ligatures` \
    neovim               `# smaller, improved version of vim` \
    tree                 `# display directory trees` \
    shopify              `# shopify CLI` \
    blackhole-2ch        `# Virtual audio driver`


### Optional

Depending on current projects

- 🐘 [Postgres.app](https://postgresapp.com/)
- 🐍 [PyCharm](https://www.jetbrains.com/pycharm/)<sup>1</sup>
- 🐳 [Docker](https://www.docker.com/products/docker-desktop)
- 📜 [Poetry](https://python-poetry.org/docs/#osx--linux--bashonwindows-install-instructions)
- With brew:
  ```zsh
  brew install \
    kubernetes-cli       `# Kubernetes utils` \
    basex                `# XML database and XPath/XQuery processor`
    
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

You can install optional completions by running `install_completions`.


## Installing Erlang

There are some known issues with `wxWidgets` on Mojave that causes the rendering of tools like the `observer` to break. On MacOS the package is called `wxmac`, and unfortunately the default version in Homebrew is too old and doesn't contain the required flags to work properly.

To work around this, as it was helpfully described in [this issue](https://github.com/asdf-vm/asdf-erlang/issues/95#issuecomment-593923921):

1. Run:
  ```zsh
  brew edit wxmac
  ```

2. Apply the following patch:
  ```diff
  diff --git a/Formula/wxmac.rb b/Formula/wxmac.rb
  index d80b02f9e..9c68e7363 100644
  --- a/Formula/wxmac.rb
  +++ b/Formula/wxmac.rb
  @@ -1,8 +1,8 @@
  class Wxmac < Formula
    desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
    homepage "https://www.wxwidgets.org"
  -  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.5/wxWidgets-3.0.5.tar.bz2"
  -  sha256 "8aacd56b462f42fb6e33b4d8f5d40be5abc3d3b41348ea968aa515cc8285d813"
  +  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.3/wxWidgets-3.1.3.tar.bz2"
  +  sha256 "fffc1d34dac54ff7008df327907984b156c50cff5a2f36ee3da6052744ab554a"
    head "https://github.com/wxWidgets/wxWidgets.git"
  
    bottle do
  @@ -19,6 +19,7 @@ class Wxmac < Formula
    def install
      args = [
        "--prefix=#{prefix}",
  +      "--enable-compat28",
        "--enable-clipboard",
        "--enable-controls",
        "--enable-dataviewctrl",
  ```

3. Install `wxmac` and compile erlang:
  ```zsh
  brew install wxmac --build-from-source
  asdf install erlang xx.x.x  # replace with actual version
  ```

4. Check that it worked:
  ```zsh
  # Don't forget to set the local/global version first :)
  erl
  1> observer:start().
  ```

5. Enjoy dark-mode Observer 😎

## Fonts

`Fira Code` is a good monospace font for coding that supports [ligatures](https://www.wikiwand.com/en/Ligature_(writing)). It can be installed using `brew` (see above).
Further config might be required depending on the editor, [see here for VSCode](https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions).

---
<sup>1</sup> Requires license/subscription (but might also have a free plan)
