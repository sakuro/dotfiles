#!/bin/bash

export DOTREPO="https://github.com/sakuro/dotfiles.git"
export DOTROOT="${DOTROOT:=$HOME/.dotfiles}"
export DOTDEST="${DOTDEST:=$HOME}"

fetch-and-eval() {
  local script
  script="$(curl "$1")" || return 1
  eval "${script}"
}

TARGET_OS="$(fetch-and-eval "https://dot.2238.club/scripts/detect-target-os.sh")" || exit 1
[[ -n "${TARGET_OS}" ]] || exit 1
fetch-and-eval "https://dot.2238.club/scripts/${TARGET_OS}/bootstrap.sh" || exit 1

if [[ ! -d "${DOTROOT}" ]]; then
  git clone "${DOTREPO}" "${DOTROOT}"
fi

make -C "$DOTROOT" setup
