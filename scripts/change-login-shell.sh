#!/bin/bash

LOGIN_SHELL=${LOGIN_SHELL:=zsh}

function current_shell()
{
  case "$OSTYPE" in
  darwin*)
    # shellcheck disable=SC2046
    set -- $(dscl localhost -read "Local/Default/Users/$USER" UserShell)
    echo "$2"
    ;;
  *)
    # shellcheck disable=SC2046
    set -- $(getent passwd "$USER" | cut -d : -f 7)
    echo "$1"
    ;;
  esac
}

# shellcheck disable=SC2046
set -- $(grep "/$LOGIN_SHELL"'$' /etc/shells | awk '{print length, $0}' | sort -n | head -n 1 | cut -d ' ' -f 2)
case $# in
0)
  echo "$LOGIN_SHELL could not be found in /etc/shells"
  exit 1
  ;;
1)
  shell_path=$1
  ;;
esac

: "${USER:=$(id --u -n)}"

current_shell=$(current_shell)
if [[ "${shell_path##*/}" = "${current_shell##*/}" ]]; then
  echo "The login shell is already $current_shell"
  exit 0
fi

# using sudo in case the user's password is not known
sudo chsh -s "${shell_path}" "$USER"
echo "The login shell is set to $(current_shell)"
