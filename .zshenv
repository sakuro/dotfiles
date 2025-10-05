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
  local -aU winpath=( ${(M)path##/mnt/*} )
  # cursor also defines code. It must come after code.
  local code_path="/mnt/c/Users/sakuro/AppData/Local/Programs/Microsoft VS Code/bin"
  local cursor_path="/mnt/c/Users/sakuro/AppData/Local/Programs/cursor/resources/app/bin"

  winpath=(
    ${(M)winpath:#"$code_path"}
    ${(M)winpath:#"$cursor_path"}
    ${(@)winpath:#"$code_path"~"$cursor_path"}
  )

  set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)
  path=($path $winpath)
}

fpath=(
  $ZDOTDIR/functions $ZDOTDIR/hooks $fpath
  /opt/homebrew/share/zsh/site-functions
  /opt/homebrew/share/zsh-completions
)
autoload -Uz ${(e)${^$(echo $ZDOTDIR/{functions,hooks}/*(@,.N))}:t}

# aqua
export AQUA_GLOBAL_CONFIG=${XDG_CONFIG_HOME}/aqua.yaml

# mise
is-executable mise && eval "$(mise activate)"

export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
export RUBYOPT="-W:deprecated -W:experimental"
export BUNDLE_USER_HOME=$XDG_CONFIG_HOME/bundle
export BUNDLE_CACHE_PATH=$XDG_CACHE_HOME/bundle

whence ipconfig >/dev/null && sudo ipconfig setverbose 1
