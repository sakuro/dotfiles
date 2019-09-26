#!/bin/bash

BREW_INSTALLER_URL=https://raw.githubusercontent.com/Homebrew/install/master/install
BREW_ORIGINAL_ROOT=/usr/local
BREW_ROOT=/opt/brew

if type -P brew > /dev/null; then
  echo "Homebrew is already installed as $(type -P brew)"
  exit 0
else
  /usr/bin/ruby -e $(curl -fsSL $(BREW_INSTALL_URL) | sed -e 's!$(BREW_ORIGINAL_ROOT)!$(BREW_ROOT)!g')
fi
