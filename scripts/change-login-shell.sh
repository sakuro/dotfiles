#!/bin/bash

LOGIN_SHELL=${LOGIN_SHELL:=zsh}

set -- $(grep "/$LOGIN_SHELL"'$' /etc/shells)
case $# in
0)
  echo "$LOGIN_SHELL could not be found in /etc/shells"
  exit 1
  ;;
1)
  shell_path=$1
  ;;
*)
  select shell_path; do
    break
  done
  ;;
esac

: ${USER:=$(id --user --name)}

case $OSTYPE in
darwin*)
  set -- $(dscl localhost -read Local/Default/Users/$USER UserShell)
  current_shell=$2
  ;;
*)
  set -- $(getent passwd $USER | cut --delimiter=: --fields=7)
  current_shell=$1
  ;;
esac

if [[ ${shell_path##*/} = ${current_shell##*/} ]]; then
  echo "The login shell is already $current_shell"
  exit 0
fi

# using sudo in case the user's password is not known
sudo chsh -s ${shell_path} $USER
