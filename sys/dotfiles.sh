#!/usr/bin/env bash

set -e

DOTREPO="https://github.com/sakuro/dotfiles.git"
DOTROOT=${DOTROOT:=$HOME/.dotfiles}
DOTDEST=${DOTDEST:=$HOME}
LOGIN_SHELL=zsh

# Return true if DRYRUN is set and its length is greater than zero
function is-dry-run() {
  [[ -n "${DRYRUN}" ]]
}

# Check if given STRING matches any of given PATTERNS(globs)
# is_member_of STRING PATTERNS
function is-member-of() {
  local v=$1
  shift
  for e; do
    case "${v}" in
    ${e}) return 0 ;;
    esac
  done
  return 1
}

# Wrapper of mkdir -p
# When DRYRUN is set, it just echos what would be done
function mkdir-p() {
  if is-dry-run; then
    echo mkdir -p "$@"
  else
    mkdir -p "$@"
  fi
}

# Wrapper of ln -s
# When DRYRUN is set, it just echos what would be done
function ln-s() {
  if is-dry-run; then
    echo ln -s "$@"
  else
    ln -s "$@"
  fi
}

function is-macos() {
  [[ "$(uname)" = "Darwin" ]]
}

function is-linux() {
  [[ "$(uname)" = "Linux" ]]
}

is-executable() {
  local command=$1
  type -P "${command}" > /dev/null
}

function macos::prepare() {
  osx::clt::should-install && osx::clt::install
}

function macos::os::version() {
  sw_vers | grep ProuctVersion | grep -Eo '10\.[0-9]+'
}

function macos::clt::should-install() {
  [[ -e /Library/Developer/CommandLineTools/usr/bin/git ]]
}

function macos::clt::install() {
  sudo /usr/bin/xcode-select --install
  echo Press any key when the installation has completed
  read
  sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
}

function macos::brew::install() {
  brew install "$@"
}

function linux::prepare() {
  linux::package::update
  for package in $(linux::package::required); do
    linux::package::install "${package}"
  done
}

function linux::yum::install() {
  sudo yum install -q -y "$@"
}

function linux::yum::update() {
  sudo yum update -q -y
}

function linux::yum::required() {
  echo git make "${LOGIN_SHELL_PACKAGE:-"${LOGIN_SHELL}"}"
}

function linux::apt-get::install() {
  sudo apt-get install -y "$@"
}

function linux::apt-get::update() {
  sudo apt-get update -y
}

function linux:apt-get::required() {
  echo git make "${LOGIN_SHELL_PACKAGE:-"${LOGIN_SHELL}"}"
}

function setup::main() {
  setup::main::should-execute || return 0
  setup::detect-os
  setup::prepare

  if [[ -d "${DOTROOT}" ]]; then
    (cd "$DOTROOT" && git pull)
  else
    git clone "${DOTREPO}" "${DOTROOT}"
  fi
  (cd "${DOTROOT}/sys" && make deploy)

  setup::chsh
}

function setup::main::should-execute() {
  [[ -z "${BASH_SOURCE[0]}" ]]
}

function setup::detect-os() {
  if is-macos; then
    function setup::prepare() {
      osx::prepare
    }
  elif is-linux; then
    function setup::prepare() {
      linux::prepare
    }
    if is-executable yum; then
      function linux::package::install() {
        linux::yum::install "$@"
      }
      function linux::package::update() {
        linux::yum::update "$@"
      }
      function linux::package::required() {
        linux::yum::required "$@"
      }
    elif is-executable apt-get; then
      function linux::package::install() {
        linux::apt-get::install "$@"
      }
      function linux::package::update() {
        linux::apt-get::update "$@"
      }
      function linux::package::required() {
        linux::apt-get::required "$@"
      }
    fi
  else
    echo Unsupported OS
    exit 1
  fi
}

function setup::chsh() {
  # if multiple paths are found, use the last one
  local shell_path="$(grep "/${LOGIN_SHELL}"'$' /etc/shells | sed '$!d')"
  # using sudo incase the user's password is not known
  if [[ -n "${shell_path}" ]]; then
    sudo chsh -s "${shell_path}" "$(id -un)"
  else
    echo "${LOGIN_SHELL} could not be found in /etc/shells"
    return 0
  fi
}

setup::main
