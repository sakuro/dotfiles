#!/bin/zsh

[[ -n "$SSH_AGENT_PID" ]] && ssh-agent -k >/dev/null

[[ $TTY == /dev/tty<-> ]] && clear
