#!/bin/bash

export DOTREPO="https://github.com/sakuro/dotfiles.git"
export DOTROOT="${DOTROOT:=$HOME/.dotfiles}"

function bootstrap-macos()
{
  if [[ ! -e /Library/Developer/CommandLineTools/usr/bin/git ]]; then
    sudo /usr/bin/xcode-select --install
    echo -n "Press any key when the installation has completed"; read answer < /dev/tty
    sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
  fi
  BOOTSTRAP=1
}

function bootstrap-ubuntu()
{
  [[ -e /usr/bin/git ]] || sudo apt install git
  [[ -e /usr/bin/make ]] || sudo apt install make
  BOOTSTRAP=1
}


unset BOOTSTRAP
case "$(uname -o)" in
Darwin)
  bootstrap-macos
  ;;
*Linux)
  for release in /etc/os-release /usr/lib/os-release; do
    if [[ -f "$release" ]]; then
      source $release
      break
    fi
  done
  case "${ID}" in
  ubuntu)
    bootstrap-ubuntu
    ;;
  esac
  ;;
esac
: ${BOOTSTRAP:?failed}

if [[ -d "${DOTROOT}" ]]; then
  (cd "$DOTROOT" && git pull)
else
  git clone "${DOTREPO}" "${DOTROOT}"
  (cd "$DOTROOT" && git submodule init && git sudmobuld update)
fi

make -C "$DOTROOT/sys" setup
