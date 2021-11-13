#!/bin/sh

LOGIN_SHELL=${LOGIN_SHELL:=zsh}

# if multiple paths are found, use the last one
local shell_path="$(grep "/${LOGIN_SHELL}"'$' /etc/shells | sed '$!d')"
if [[ -z "${shell_path}" ]]; then
  echo "${LOGIN_SHELL} could not be found in /etc/shells"
  exit 0
fi

set -- $(dscl localhost -read Local/Default/Users/$USER UserShell)
local current_shell=$2
if [[ $shell_path = $current_shell ]]; then
  echo "The login shell is already ${current_shell}"
  exit 0
fi

# using sudo incase the user's password is not known
sudo chsh -s "${shell_path}" "$(id -un)"
