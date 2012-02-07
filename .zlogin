#!/bin/zsh

if [[ -t 0 ]] && is_executable fortune; then
  echo ""
  echo "Fortune of the day:"
  fortune -s
  echo ""
fi

is_executable screen && screen -list

if [[ -z "$SSH_AUTH_SOCK" ]]; then
  echo -n "Invoking SSH agent: "
  eval $(ssh-agent)
  ssh-add
  echo ""
fi
