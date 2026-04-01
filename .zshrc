. $HOME/.pathrc
. $HOME/.completions
. $HOME/.aliases
type mise > /dev/null && eval "$(mise activate zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Optional private configuration, not in git
[ -f ~/.privaterc ] && source ~/.privaterc

type direnv > /dev/null && eval "$(direnv hook zsh)"

if [[ $- == *i* ]]; then
  # Enable zoxide only in interactive mode
  type zoxide > /dev/null && eval "$(zoxide init zsh)"
  type zoxide > /dev/null && alias cd='z'
fi

type starship > /dev/null && eval "$(starship init zsh)"

# Vim keybindings
bindkey -v

# History (has to come after vim keybindings for history substring search bindings to work)
. $HOME/.historyrc

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Move to directories without cd
# setopt autocd

echo "👋 'ello!"
