#!/bin/zsh

setopt no_global_rcs
umask 022
ulimit -c unlimited

export XDG_CONFIG_HOME=$HOME/.config
[[ -d $XDG_CONFIG_HOME ]] || mkdir -p $XDG_CONFIG_HOME

export XDG_CACHE_HOME=$HOME/.cache
[[ -d $XDG_CACHE_HOME ]] || mkdir -p $XDG_CACHE_HOME

export XDG_DATA_HOME=$HOME/.local/share
[[ -d $XDG_DATA_HOME ]] || mkdir -p $XDG_DATA_HOME

ZDOTDIR=$XDG_CONFIG_HOME/zsh

typeset -aU path

() {
  local winpath=( ${(M)path##/mnt*} )
  set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)
  path=($path $winpath)
}

fpath=(
  $ZDOTDIR/functions $fpath
  /opt/homebrew/share/zsh/site-functions
  /opt/homebrew/share/zsh-completions
)
autoload -Uz ${(e)${^$(echo $ZDOTDIR/functions/*(@,.N))}:t}

# asdf
[[ -f ~/.asdf/asdf.sh ]] && source $HOME/.asdf/asdf.sh
