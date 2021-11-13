#!/bin/bash

# Remove elements which end with /gnubin or ~/bin from $PATH
IFS=: read -r -a path <<<"$PATH"
PATH=""
set -- "${path[@]}"
while [[ $# -gt 0 ]]; do
  case $1 in
  */gnubin|$HOME/bin)
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

type -P brew > /dev/null && exit 0
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Some formulae require java cask be installed, but in Brewfile, casks are
# listed after formulae, so this must be installed beforehand
/usr/libexec/java_home >/dev/null 2>/dev/null || brew install java

type -P mas > /dev/null || brew install mas
mas_account="$(mas account)"
until [[ $? = 0 ]]; do
  echo "Log in to the AppStore and press any key" && read answer < /dev/tty
  mas_account="$(mas account)"
done
echo "Using the AppStore account: ${mas_account}"
