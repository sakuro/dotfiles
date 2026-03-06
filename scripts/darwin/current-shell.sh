#!/bin/bash

# shellcheck disable=SC2046
set -- $(dscl localhost -read "Local/Default/Users/$USER" UserShell)
echo "$2"
