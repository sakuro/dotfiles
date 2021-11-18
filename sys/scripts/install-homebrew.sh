#!/bin/bash

PATH=/opt/homebrew/bin:$(eval $(/usr/libexec/path_helper))
type -P brew > /dev/null && exit 0
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

type -P mas > /dev/null || brew install mas
mas_account="$(mas account)"
until [[ $? = 0 ]]; do
  echo "Log in to the AppStore and press any key" && read answer < /dev/tty
  mas_account="$(mas account)"
done
echo "Using the AppStore account: ${mas_account}"
