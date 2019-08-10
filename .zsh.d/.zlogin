#!/bin/zsh

if tty -s && [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval $(ssh-agent) >/dev/null
  ssh-add 2>/dev/null
fi

if is-executable tmux; then
  if in-vscode-terminal && ! in-tmux-session; then
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
      ;;
    *)
      local session=$(echo "${(F)sessions}\nN:ew session\nD:on't attach" | peco --prompt "Session to attach:" | cut -d: -f1)
      case $session in
      N)
        tmux new-session
        ;;
      D)
        ;;
      *)
        tmux attach-session -t $session
        ;;
      esac
      ;;
    esac
  fi
fi
