#!/bin/bash

export DOTREPO="https://github.com/sakuro/dotfiles.git"
export DOTROOT="${DOTROOT:=$HOME/.dotfiles}"
export DOTDEST=${DOTDEST:=$HOME}

BASE_URL="https://dot.2238club.org"

case "${OSTYPE}" in
darwin*)
  bash -c $(curl -fsSL "$BASE_URL/bootstarp-macos.sh")
  ;;
*linux*)
  bash -c $(curl -fsSL "$BASE_URL/bootstarp-linux.sh")
  ;;
*)
  echo "Unsupported OS: $OSTYPE"
  exit 1
  ;;
esac

if [[ ! -d "${DOTROOT}" ]]; then
  git clone "${DOTREPO}" "${DOTROOT}"
  (cd "$DOTROOT" && git submodule init && git submodule update)
fi

make -d "$DOTROOT" setup
