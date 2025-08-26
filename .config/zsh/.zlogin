#!/bin/zsh

[[ "$SHLVL" -le 1 ]] && {
  if is-executable fasti; then
    echo
    fasti
    echo
  elif is-executable cal; then
    echo
    cal
    echo
  fi
}
