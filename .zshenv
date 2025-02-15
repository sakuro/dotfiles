#!/bin/zsh

setopt no_global_rcs
umask 022
ulimit -c unlimited

export XDG_CONFIG_HOME=$HOME/.config
[[ -d $XDG_CONFIG_HOME ]] || mkdir --parents $XDG_CONFIG_HOME

if [[ -d $HOME/Library/Caches ]]; then
  export XDG_CACHE_HOME=$HOME/Library/Caches
else
  export XDG_CACHE_HOME=$HOME/.cache
  [[ -d $XDG_CACHE_HOME ]] || mkdir --parents $XDG_CACHE_HOME
fi

export XDG_DATA_HOME=$HOME/.local/share
[[ -d $XDG_DATA_HOME ]] || mkdir --parents $XDG_DATA_HOME

ZDOTDIR=$XDG_CONFIG_HOME/zsh

typeset -aU path

() {
  local winpath=( ${(M)path##/mnt*} )
  set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)
  path=($path $winpath)
}

fpath=(
  $ZDOTDIR/functions $ZDOTDIR/hooks $fpath
  /opt/homebrew/share/zsh/site-functions
  /opt/homebrew/share/zsh-completions
)
autoload -Uz ${(e)${^$(echo $ZDOTDIR/{functions,hooks}/*(@,.N))}:t}

# mise
is-executable mise && {
  case "$-" in
  *i*)
    eval "$(mise activate)"
    ;;
  *)
    eval "$(mise activate --shims)"
    ;;
  esac
}


export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
export RUBYOPT="-W:deprecated -W:experimental"
