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
  else
    local sessions=( ${(f)"$(tmux list-sessions 2>/dev/null)"} )
    case $#sessions in
    0)
      exec tmux new-session
      ;;
    1)
      exec tmux attach-session
      ;;
    *)
      local session=$(echo "${(F)sessions}" | peco --prompt "Session to attach:" | cut -d: -f1)
      if [[ -n "$session" ]]; then
        exec tmux attach-session -t $session
      fi
      ;;
    esac
  fi
fi
