#!/bin/bash

export DOTREPO="https://github.com/sakuro/dotfiles.git"
export DOTROOT="${DOTROOT:=$HOME/.dotfiles}"
export DOTDEST=${DOTDEST:=$HOME}

function bootstrap-macos()
{
  if [[ ! -e /Library/Developer/CommandLineTools/usr/bin/git ]]; then
    sudo /usr/bin/xcode-select --install
    echo -n "Press any key when the installation has completed"; read answer < /dev/tty
    sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
  fi
}

case "${OSTYPE}" in
darwin*)
  bootstrap-macos
  ;;
*)
  echo "Unsupported OS: $OSTYPE"
  exit 1
  ;;
esac

if [[ ! -d "${DOTROOT}" ]]; then
  git clone "${DOTREPO}" "${DOTROOT}"
  (cd "$DOTROOT" && git submodule init && git sudmobule update)
fi

(cd "$DOTROOT" && make setup)
