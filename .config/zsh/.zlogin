#!/bin/zsh

autoload -U compinit
compinit -u -d $XDG_CACHE_HOME/zsh/compdump

if tty --silent; then
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval $(ssh-agent) >/dev/null
    ssh-add 2>/dev/null
  fi
fi
