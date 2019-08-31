#!/bin/zsh

setopt no_global_rcs
export XDG_CONFIG_HOME=$HOME/.config
[[ -d $XDG_CONFIG_HOME ]] || mkdir -p $XDG_CONFIG_HOME
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

fpath=($ZDOTDIR/functions $fpath)

typeset -aU path
set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)

ulimit -c unlimited
umask 022

export TIME_STYLE=long-iso
export QUOTING_STYLE=literal

# dot
export DOT_REPO=https://github.com/skauro/dotfiles.git
export DOT_DIR=$HOME/.dotfiles
