. $HOME/.completions
. $HOME/.ziminit
. $HOME/.aliases
. $HOME/.env
. $HOME/.pathrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Optional private configuration, not in git
[ -f ~/.privaterc ] && source ~/.privaterc

echo "👋 'ello!"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
