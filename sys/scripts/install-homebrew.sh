#!/bin/bash

PATH=
eval "$(/usr/libexec/path_helper)"
type -P brew > /dev/null && exit 0
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
