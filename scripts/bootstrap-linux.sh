#!/bin/bash

[[ -f /etc/os-release ]] || {
  echo "Unknown Linux (/etc/os-release does not exist)"
  exit 1
}

# shellcheck disable=SC1091
source /etc/os-release

for id in "$ID" "$ID_LIKE"; do
  case "$id" in
  debian)
    bootstrap-linux-debian && return 0
    ;;
  esac
done
echo "Unsupported Linux: ID: ${ID}, ID_LIKE: ${ID_LIKE}, PRETTY_NAME: ${PRETTY_NAME}"
exit 1

function bootstrap-linux-debian()
{
  sudo apt update && sudo apt install --yes git make zsh lsb-release
}
