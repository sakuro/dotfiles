#!/bin/zsh

ZDOTDIR=$HOME/.zsh.d
fpath=($ZDOTDIR/*(/N) $fpath)
autoload ${(e)${^$(echo $ZDOTDIR/functions/*(.N))}:t}

typeset -aU path
set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)

ulimit -c unlimited
umask 022

export TIME_STYLE=long-iso
export _JAVA_OPTIONS=-Dfile.encoding=UTF-8

# rbenv
whence rbenv >/dev/null && eval "$(rbenv init -)"
