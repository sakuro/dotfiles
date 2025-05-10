#!/bin/bash

export DOTREPO="https://github.com/sakuro/dotfiles.git"
export DOTROOT="${DOTROOT:=$HOME/.dotfiles}"
export DOTDEST="${DOTDEST:=$HOME}"

eval "$(curl https://dot.2238club.org/scripts/util.sh)"
eval "$(curl https://dot.2238club.org/scripts/bootstrap/$(os).sh)"

if [[ ! -d "${DOTROOT}" ]]; then
  git clone "${DOTREPO}" "${DOTROOT}"
  (cd "$DOTROOT" && git submodule init && git submodule update)
fi

make -d "$DOTROOT" setup
