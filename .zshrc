. $HOME/.historyrc
. $HOME/.pathrc
. $HOME/.completions
. $HOME/.aliases
. $HOME/.mise-en-place
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Optional private configuration, not in git
[ -f ~/.privaterc ] && source ~/.privaterc

[ -f "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ] && source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"

type direnv > /dev/null && eval "$(direnv hook zsh)"
type zoxide > /dev/null && eval "$(zoxide init zsh)"
type starship > /dev/null && eval "$(starship init zsh)"

# Vim keybindings
bindkey -v

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Move to directories without cd
# setopt autocd

echo "👋 'ello!"
