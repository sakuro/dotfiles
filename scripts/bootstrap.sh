#!/bin/bash

export DOTREPO="https://github.com/sakuro/dotfiles.git"
export DOTROOT="${DOTROOT:=$HOME/.dotfiles}"
export DOTDEST="${DOTDEST:=$HOME}"

TARGET_OS="$(eval "$(curl https://dot.2238.club/scripts/detect-target-os.sh)")"
eval "$(curl https://dot.2238.club/scripts/${TARGET_OS}/bootstrap.sh)"

if [[ ! -d "${DOTROOT}" ]]; then
  git clone "${DOTREPO}" "${DOTROOT}"
fi

make -C "$DOTROOT" setup
