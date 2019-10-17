#!/bin/zsh

setopt no_global_rcs

export XDG_CONFIG_HOME=$HOME/.config
[[ -d $XDG_CONFIG_HOME ]] || mkdir -p $XDG_CONFIG_HOME

export XDG_CACHE_HOME=$HOME/.cache
[[ -d $XDG_CACHE_HOME ]] || mkdir -p $XDG_CACHE_HOME

export ZDOTDIR=$XDG_CONFIG_HOME/zsh

ulimit -c unlimited
umask 022
