. $HOME/.completions
. $HOME/.ziminit
. $HOME/.aliases
. $HOME/.env
. $HOME/.pathrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Optional private configuration, not in git
[ -f ~/.privaterc ] && source ~/.privaterc

echo "👋 'ello!"