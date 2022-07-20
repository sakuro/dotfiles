#!/bin/bash

function install_source_list()
{
    # GitHub CLI
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
}

case "${OSTYPE}" in
darwin*)
    eval "$(/usr/libexec/path_helper)"
    PATH=/opt/homebrew/bin:$PATH
    type -P brew > /dev/null || scripts/install-homebrew.sh
    brew bundle --no-lock
    chmod go-w "$(brew --prefix)/share"
    ;;
*linux*)
    [[ -f /etc/os-release ]] || {
      echo "Unknown Linux (/etc/os-release does not exist)"
      exit 1
    }
    # shellcheck disable=SC1091
    source /etc/os-release

    case $ID in
    debian)
      install_source_list
      sudo apt update
      # shellcheck disable=SC2046
      sudo apt install --yes $(cat apt-packages.txt)
      ;;
    *)
      echo "Unsupported Linux: $ID / $PRETTY_NAME"
      exit 1
      ;;
    esac
    ;;
*)
    echo "Unsupported OS: $OSTYPE"
    exit 1
    ;;
esac
