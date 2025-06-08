#!/bin/bash

source $(dirname "${BASH_SOURCE:-$0}")/util.sh

function install-packages-darwin()
{
  eval "$(/usr/libexec/path_helper)"
  PATH=/opt/homebrew/bin:$PATH
  [[ -x /opt/homebrew/bin/brew ]] || scripts/install-homebrew.sh
  brew bundle
  chmod go-w "$(brew --prefix)/share"
}

function install-packages-linux-debian()
{
  # shellcheck disable=SC2046
  sudo apt install --yes $(cat apt-packages.txt)
}

install-packages-$(os)
