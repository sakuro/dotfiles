#!/bin/bash

. $(dirname $0)/../dotfiles.sh

EXCLUDED_PATTERNS=(
  README.md
  sys/*
  */.gitignore
)

if is-linux; then
  EXCLUDED_PATTERNS+=(
    Library/*
    iCloud
  )
fi

function list-targets() {
  (cd ${DOTROOT} && git ls-files) | while read item; do
    is-member-of "${item}" "${EXCLUDED_PATTERNS[@]}" || echo "${item}"
  done
}

function make-link() {
  local file="$1"

  local from="$DOTROOT/${file}"
  local to="$DOTDEST/${file}"
  local dir="$(dirname "$file")"

  [[ "{$dir}" = "." ]] || [[ -d "$DOTDEST/$dir" ]] || mkdir-p "$DOTDEST/$dir"
  if [[ -e "$to" || -h "$to" ]]; then
    echo "${to} already exists"
  else
    ln-s "$from" "$to"
  fi
}

[[ -d $DOTDEST ]] || mkdir-p "$DOTDEST"

list-targets | while read file; do
  make-link "$file"
done
