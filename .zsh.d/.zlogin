#!/bin/zsh

if is-executable fortune; then
  fortune -s
  echo ""
fi

if tty -s && [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval $(ssh-agent) >/dev/null
  ssh-add 2>/dev/null
fi
