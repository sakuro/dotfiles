#!/bin/bash

source $(dirname "${BASH_SOURCE:-0}")/util.sh

function install-packages-darwin()
{
  eval "$(/usr/libexec/path_helper)"
  PATH=/opt/homebrew/bin:$PATH
  type -P brew > /dev/null || scripts/install-homebrew.sh
  brew bundle --no-lock
  chmod go-w "$(brew --prefix)/share"
}

function install-packages-linux-debian()
{
  install-source-list
  sudo apt update
  # shellcheck disable=SC2046
  sudo apt install --yes $(cat apt-packages.txt)
}

function install-source-list()
{
    # GitHub CLI
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
}

install-packages-$(os)
