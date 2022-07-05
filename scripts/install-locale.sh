#!/bin/bash

case "${OSTYPE}" in
darwin*)
    ;;
*linux*)
    [[ -f /etc/os-release ]] || {
      echo "Unknown Linux (/etc/os-release does not exist)"
      exit 1
    }
    # shellcheck disable=SC1091
    source /etc/os-release

    case $ID in
    debian)
      sudo apt install --yes locales
      sudo sed -i -e '/ja_JP.UTF-8/s/^# *//'
      sudo locale-gen
      ;;
    *)
      echo "Unsupported Linux: $ID / $PRETTY_NAME"
      exit 1
      ;;
    esac
    ;;
*)
    echo "Unsupported OS: $OSTYPE"
    exit 1
    ;;
esac
