#!/bin/bash

case "${OSTYPE}" in
darwin*)
    PATH=/opt/homebrew/bin:$(eval $(/usr/libexec/path_helper))
    type -P brew > /dev/null || scripts/install-homebrew.sh
    brew bundle --no-lock
    chmod go-w "$(brew --prefix)/share"
    ;;
*)
    echo "Unsupported OS: $OSTYPE"
    exit 1
    ;;
esac
