#!/bin/zsh

if [[ -t 0 ]] && whence fortune >/dev/null; then
  echo ""
  echo "Fortune of the day:"
  fortune -s
  echo ""
fi

whence screen >/dev/null && screen -list

if [[ -z "$SSH_AUTH_SOCK" ]]; then
  echo -n "Invoking SSH agent: "
  eval $(ssh-agent)
  ssh-add
  echo ""
fi
