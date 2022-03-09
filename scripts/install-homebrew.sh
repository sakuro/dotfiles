#!/bin/bash

eval "$(/usr/libexec/path_helper)"
PATH=/opt/homebrew/bin:$PATH
type -P brew > /dev/null && exit 0
bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

type -P mas > /dev/null || brew install mas
if [[ "${$(sw_vers -productVersion)%%.*}" -lt 12 ]]; then
  until mas_account="$(mas account)"; do
    echo "Log in to the AppStore and press ENTER" && read -r < /dev/tty
  done
  echo "Using the AppStore account: ${mas_account}"
fi
