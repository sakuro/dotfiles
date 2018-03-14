#!/bin/zsh

if is-executable fortune; then
  fortune -s
  echo ""
fi

if tty -s && [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval $(ssh-agent) >/dev/null
  ssh-add 2>/dev/null
fi

if is-executable tmux && [[ -z "$TMUX" ]]; then
  # tmux is available but not in a session
  if [[ "$TERM_PROGRAM" = "vscode" && -n "$VSCODE_PID" ]]; then
    tmux_session="vscode-$(pwd|md5)"
    if tmux ls -F '#S' 2>/dev/null | grep -qF "$tmux_session"; then
      exec tmux attach-session -d -t "$tmux_session"
    else
      exec tmux new-session -s "$tmux_session"
    fi
  else
    exec tmux new-session
  fi
fi
