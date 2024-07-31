. $HOME/.completions
. $HOME/.ziminit
. $HOME/.aliases
. $HOME/.pathrc
. $HOME/.mise-en-place

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Optional private configuration, not in git
[ -f ~/.privaterc ] && source ~/.privaterc

eval "$(direnv hook zsh)"

echo "👋 'ello!"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
