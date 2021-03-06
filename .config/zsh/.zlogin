#!/bin/zsh

autoload -U compinit
compinit -u -d $ZDOTDIR/compdump

if tty -s; then
  cd $HOME
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval $(ssh-agent) >/dev/null
    ssh-add 2>/dev/null
  fi
fi

interactive-start-tmux-session
