#!/bin/bash

export DOTREPO="https://github.com/sakuro/dotfiles.git"
export DOTROOT="${DOTROOT:=$HOME/.dotfiles}"
export DOTDEST=${DOTDEST:=$HOME}

function bootstrap-macos()
{
  if [[ ! -e /Library/Developer/CommandLineTools/usr/bin/git ]]; then
    sudo /usr/bin/xcode-select --install
    echo -n "Press ENTER when the installation has completed"; read -r < /dev/tty
    sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
  fi
}

function bootstrap-linux()
{
  [[ -f /etc/os-release ]] || {
    echo "Unknown Linux (/etc/os-release does not exist)"
    exit 1
  }

  # shellcheck disable=SC1091
  source /etc/os-release

  case $ID in
  debian)
    bootstrap-linux-debian
    ;;
  *)
    echo "Unsupported Linux: $ID / $PRETTY_NAME"
    exit 1
    ;;
  esac
}

function bootstrap-linux-debian()
{
  sudo apt update && sudo apt install --yes git make zsh
}

case "${OSTYPE}" in
darwin*)
  bootstrap-macos
  ;;
*linux*)
  bootstrap-linux
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

make --directory "$DOTROOT" setup
