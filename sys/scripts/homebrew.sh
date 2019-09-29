#!/bin/bash

. $(dirname $0)/../dotfiles.sh

BREW_INSTALLER_URL=https://raw.githubusercontent.com/Homebrew/install/master/install
BREW_ORIGINAL_ROOT=/usr/local

PATH="${BREW_ROOT}/bin:$PATH"

# Remove elements which end with /gnubin from $PATH
IFS=: read -r -a path <<<"$PATH"
PATH=""
set -- "${path[@]}"
while [[ $# -gt 0 ]]; do
  case $1 in
  */gnubin)
    ;;
  *)
    if [[ -z "$PATH" ]]; then
      PATH="$1"
    else
      PATH="${PATH}:$1"
    fi
    ;;
  esac
  shift
done

if is-executable brew; then
  echo "Homebrew is already installed"
else
  /usr/bin/ruby -e "$(curl -fsSL "${BREW_INSTALLER_URL}" | sed -e "s!${BREW_ORIGINAL_ROOT}!${BREW_ROOT}!g")"
fi

# Some formulae require java cask be installed, but in Brewfile, casks are
# listed after formulae, so this must be installed beforehand
if /usr/libexec/java_home >/dev/null 2>/dev/null; then
  :
else
  brew cask install java
fi

if is-executable mas; then
  :
else
  brew install mas
fi

mas_account="$(mas account)"
until [[ $? = 0 ]]; do
  echo "Log in to the AppStore and press any key" && read answer < /dev/tty
  mas_account="$(mas account)"
done
echo "Using the AppStore account: ${mas_account}"

brew bundle
