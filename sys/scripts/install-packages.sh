#!/bin/bash

case "${OSTYPE}" in
darwin*)
    eval "$(/usr/libexec/path_helper)"
    PATH=/opt/homebrew/bin:$PATH
    type -P brew > /dev/null || scripts/install-homebrew.sh
    if [[ $(uname -m) = *arm64* ]] && [[ $(arch) = i386 ]]; then
        arch -arch arm64 brew bundle --no-lock
    else
        brew bundle --no-lock
    fi
    chmod go-w "$(brew --prefix)/share"
    ;;
*)
    echo "Unsupported OS: $OSTYPE"
    exit 1
    ;;
esac
