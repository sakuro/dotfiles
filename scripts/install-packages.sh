#!/bin/bash

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
      sudo apt
      sudo apt install --yes less tmux vim zsh
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
