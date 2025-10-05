#!/bin/zsh

[[ "$SHLVL" -le 1 ]] && {
  if (( $+commands[fasti] )); then
    echo
    fasti
    echo
  elif (( $+commands[cal] )); then
    echo
    cal
    echo
  fi
}
