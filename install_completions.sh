#!/bin/zsh

# Custom directory for adding completions,
# already added to FPATH in .completions
mkdir -p ~/.zfunc

# Init heroku completions
if type heroku > /dev/null; then
    heroku autocomplete --refresh-cache
fi

# Init poetry completions
if type poetry > /dev/null; then
    poetry completions zsh > ~/.zfunc/_poetry
fi

