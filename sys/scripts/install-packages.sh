#!/bin/bash

: ?${TARGET?:}

case "${TARGET}" in
macos)
    type -P brew > /dev/null || scripts/install-homebrew.sh
    brew bundle --no-lock
    chmod go-w "$(brew --prefix)/share"
    ;;
ubuntu)
    echo "Not implemented"
    ;;
esac
