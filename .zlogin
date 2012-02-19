#!/bin/zsh

if whence fortune >/dev/null; then
  fortune -s
  echo ""
fi

if whence tmux >/dev/null; then
  echo "tmux session(s):"
  tmux list-sessions
  echo ""
fi

if [[ -z "$SSH_AUTH_SOCK" ]]; then
  echo -n "Invoking SSH agent: "
  eval $(ssh-agent)
  ssh-add
  echo ""
fi
