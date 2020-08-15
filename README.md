# dotfiles

Just my dotfiles and other setup resources.

## New Laptop Setup

Before installing the dotfiles it may be a good idea to install some of the things below.

### General

#### Essentials

- ⌨️ [iTerm2](https://www.iterm2.com/)
- 🍺 [Brew](https://brew.sh/)
- 🦊 [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- 🔑 [LastPass](https://lastpass.com/misc_download2.php)<sup>1</sup>
- ✉️ [Mailplane](https://mailplaneapp.com/)<sup>1</sup>
- 🦠 [ClamXAV](https://www.clamxav.com/)<sup>1</sup>
- 📦 [Dropbox](https://www.dropbox.com/)
- 📝 [Notion](https://www.notion.so/desktop)<sup>1</sup>
- 💬 [Slack](https://slack.com/intl/en-de/downloads/mac)
- 📞 [Zoom](https://zoom.us/download)

#### Might be needed later

Usually don't need to be install straight away.

- 🧲 [Magnet](https://magnet.crowdcafe.com/)<sup>1</sup>
- 🎩 [Alfred](https://www.alfredapp.com/)<sup>1</sup>
- 📦 [Google Drive](https://www.google.com/drive/download/)
- 👓 [Adobe Reader](https://get.adobe.com/uk/reader/)
- 📽 [Deckset](https://www.deckset.com/)<sup>1</sup>
- 📱 [Franz](https://meetfranz.com/)
- ⏺ [Gifox](https://gifox.io/) (v1)<sup>1</sup>
- 🖋 [Grammarly](https://app.grammarly.com/)<sup>1</sup>
- 🗝 [Keybase](https://keybase.io/docs/the_app/install_macos)
- 💼 [Office 365](https://www.office.com/)<sup>1</sup>
- ☊ [Mindnode](https://mindnode.com/)<sup>1</sup>
- 📸 [Skitch](https://evernote.com/products/skitch)
- 🦈 [Surfshark](https://surfshark.com/)<sup>1</sup>

### Concentration

- 🎯[Todoist](https://todoist.com/downloads/mac)<sup>1</sup>
- 🍅 [Pomodone](https://pomodoneapp.com/download-pomodone-app.html)<sup>1</sup>
- 🎧 [Spotify](https://www.spotify.com/de/download/mac/)<sup>1</sup>

### Development

#### Must-have

- 💻 [Visual Studio Code](https://code.visualstudio.com/)
  <br>Use [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) pointing to the correct Gist.
- 📯 [Postman](https://www.postman.com/downloads/)
- 📑 [Dash](https://kapeli.com/dash)<sup>1</sup>
- 🌐 [Chrome](https://www.google.com/chrome/)
- With brew:
  ```zsh
  brew install \
    antigen              # light-weight alternative to oh-my-zsh
    git                  # latest git version
    hub                  # Github CLI
    coreutils            # GNU core utils (required by asdf)
    curl                 # curl :)
    asdf                 # runtume version manager
    the_silver_searcher  # faster `ack`
    ripgrep              # even faster `ack`
    diffmerge            # old-school 3-way merge
    diff-so-fancy        # nicer-looking diffs
    fzf                  # fuzzy finder
    jq                   # `sed` for JSON
    kube-ps1             # Kubernetes prompt
    watch                # 👀
  ```

- Extra casks:
  ```zsh
  brew cask install \
    blackhole            # Virtual audio driver
    java                 # You *will* eventually need it...
  ```

#### Optional

Depending on current projects

- 🐘 [Postgres.app](https://postgresapp.com/)
- 🐍 [PyCharm](https://www.jetbrains.com/pycharm/)<sup>1</sup>
- 🐳 [Docker](https://www.docker.com/products/docker-desktop)
- With brew:
  ```zsh
  brew install \
    kubernetes-cli       # Kubernetes utils
    wxmac                # wxwidgets to compile Erlang/OTP with Observer
    basex                # XML database and XPath/XQuery processor
  ```

### Dotfiles

Assuming you checkout this repo in your `$HOME` directory, you can run the following to symlink all the dotfiles:

```zsh
ln -siF dotfiles/.*(.) .
```

⚠️ The above will prompt you about replacing existing dotfiles in case there's something you'd rather keep. The `.git` directory (and any other directory) is ignored.

---
<sup>1</sup> Requires license/subscription (but might also have a free plan)
