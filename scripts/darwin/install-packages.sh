#!/bin/bash

eval "$(/usr/libexec/path_helper)"
PATH=/opt/homebrew/bin:$PATH
[[ -x /opt/homebrew/bin/brew ]] || {
    bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
brew bundle
chmod go-w "$(brew --prefix)/share"
