#!/bin/sh

if [[ ! -e /Library/Developer/CommandLineTools/usr/bin/git ]]; then
  sudo /usr/bin/xcode-select --install
  echo -n "Press ENTER when the installation has completed"; read -r < /dev/tty
  sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
fi
