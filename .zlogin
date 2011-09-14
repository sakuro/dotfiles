#!/bin/zsh

[[ -t 0 ]] && is_executable fortune && {
  echo ""
  echo "Fortune of the day:"
  fortune -s
  echo ""
}

is_executable screen && screen -list

[[ -n "$SSH_AUTH_SOCK" ]] || {
  echo -n "Invoking SSH agent: "
  eval `ssh-agent`
  ssh-add
  echo ""
}
