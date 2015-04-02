#!/bin/zsh

if whence fortune >/dev/null; then
  fortune -s
  echo ""
fi

if tty --quiet && [[ -z "$SSH_AUTH_SOCK" ]]; then
  echo -n "Invoking SSH agent: "
  eval $(ssh-agent)
  ssh-add
  echo ""
fi

[[ -z "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]] && {
  if tmux ls >/dev/null; then
    exec tmux attach
  else
    exec tmux
  fi
}
