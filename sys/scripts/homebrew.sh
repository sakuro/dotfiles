#!/bin/bash

. $(dirname $0)/../dotfiles.sh

BREW_INSTALLER_URL=https://raw.githubusercontent.com/Homebrew/install/master/install
BREW_ORIGINAL_ROOT=/usr/local
BREW_ROOT=/opt/brew

if is-executable brew; then
  echo "Homebrew is already installed"
  exit 0
else
  /usr/bin/ruby -e "$(curl -fsSL "${BREW_INSTALLER_URL}" | sed -e "s!${BREW_ORIGINAL_ROOT}!${BREW_ROOT}!g")"
fi
