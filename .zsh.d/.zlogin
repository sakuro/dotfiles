#!/bin/zsh

if is-executable fortune; then
  fortune -s
  echo ""
fi

if tty -s && [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval $(ssh-agent) >/dev/null
  ssh-add 2>/dev/null
fi

if is-executable tmux; then
  if in-vscode-terminal; then
    local tmux_session="vscode-$(pwd|md5)"
    if tmux-find-session $tmux_session; then
      exec tmux attach-session -d -t "$tmux_session"
    else
      exec tmux new-session -s "$tmux_session"
    fi
  fi
fi
