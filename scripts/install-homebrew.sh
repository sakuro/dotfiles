#!/bin/bash

eval "$(/usr/libexec/path_helper)"
PATH=/opt/homebrew/bin:$PATH
type -P brew > /dev/null && exit 0
bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

type -P mas > /dev/null || brew install mas
mas_account="$(mas account)"
# shellcheck disable=SC2181
until [[ $? = 0 ]]; do
  echo "Log in to the AppStore and press ENTER" && read -r < /dev/tty
  mas_account="$(mas account)"
done
echo "Using the AppStore account: ${mas_account}"
