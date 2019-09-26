#!/bin/bash

DOTROOT=${DOTROOT:=$HOME/.dotfiles}
DOTDEST=${DOTDEST:=$HOME}

EXCLUDED_PATTERNS=(
  README.md
  sys/*
  */.gitignore
)

# Check if given STRING matches any of given PATTERNS(globs)
# is_member_of STRING PATTERNS
function is_member_of() {
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
function mkdir_p() {
  if [[ -n "${DRYRUN}" ]]; then
    echo mkdir -p "$@"
  else
    mkdir -p "$@"
  fi
}

# Wrapper of ln -s
# When DRYRUN is set, it just echos what would be done
function ln_s() {
  if [[ -n "${DRYRUN}" ]]; then
    echo ln -s "$@"
  else
    ln -s "$@"
  fi
}

function is_macos() {
  [[ "$(name)" = "Darwin" ]]
}

function is_linux() {
  [[ "$(name)" = "Linux" ]]
}
