#!/bin/bash

case "${OSTYPE}" in
darwin*)
    eval "$(/usr/libexec/path_helper)"
    PATH=/opt/homebrew/bin:$PATH
    type -P brew > /dev/null || scripts/install-homebrew.sh
    brew bundle --no-lock
    chmod go-w "$(brew --prefix)/share"
    ;;
*)
    echo "Unsupported OS: $OSTYPE"
    exit 1
    ;;
esac
