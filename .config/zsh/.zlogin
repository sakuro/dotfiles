#!/bin/zsh

autoload -U compinit
compinit -u -d $XDG_CACHE_HOME/zsh/compdump

[[ "$SHLVL" -le 1 ]] && cal
