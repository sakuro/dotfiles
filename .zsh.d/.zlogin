#!/bin/zsh

if whence fortune >/dev/null; then
  fortune -s
  echo ""
fi

if tty -s && [[ -z "$SSH_AUTH_SOCK" ]]; then
  echo -n "Invoking SSH agent: "
  eval $(ssh-agent)
  ssh-add
  echo ""
fi
