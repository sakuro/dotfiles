#!/bin/zsh

setopt no_global_rcs

ZDOTDIR=$HOME/.zsh.d
fpath=($ZDOTDIR/*(/N) $fpath)
autoload -Uz ${(e)${^$(echo $ZDOTDIR/functions/*(.N))}:t}

typeset -aU path
set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)

ulimit -c unlimited
umask 022

export TIME_STYLE=long-iso
export QUOTING_STYLE=literal

# go
export GOPATH=$HOME/.go

# direnv
is-executable direnv && eval "$(direnv hook zsh)"

# rbenv
is-executable rbenv && eval "$(rbenv init -)"

export TMPDIR=$HOME/tmp
