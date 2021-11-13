#!/bin/bash

export DOTREPO="https://github.com/sakuro/dotfiles.git"
export DOTROOT=${DOTROOT:=$HOME/.dotfiles}
export LOGIN_SHELL=zsh

# return if sourced
[[ -z "${BASH_SOURCE[0]}" ]] && return 0

function bootstrap-macos()
{
  if [[ ! -e /Library/Developer/CommandLineTools/usr/bin/git ]]; then
    sudo /usr/bin/xcode-select --install
    echo -n "Press any key when the installation has completed"; read answer < /dev/tty
    sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
  fi
}

os="$(uname -o)"
case $os in
Darwin)
  bootstrap-macos
  ;;
*)
  echo "Unsupported OS: $os"
  exit 1
  ;;
esac

if [[ -d "${DOTROOT}" ]]; then
  (cd "$DOTROOT" && git pull)
else
  git clone "${DOTREPO}" "${DOTROOT}"
fi

make -C "$DOTROOT/sys" setup
