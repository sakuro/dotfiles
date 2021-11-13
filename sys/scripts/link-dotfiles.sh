#!/bin/bash

: "${DOTROOT:?} "${DOTDEST:?}

EXCLUDED_PATTERNS=(
  README.md
  dist/*
  sys/*
  */.gitignore
  .gitmodules
)

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

function make-link() {
  local file="$1"

  local from="$DOTROOT/${file}"
  local to="$DOTDEST/${file}"
  local dir="$(dirname "$file")"

  [[ "{$dir}" = "." ]] || [[ -d "$DOTDEST/$dir" ]] || mkdir -p "$DOTDEST/$dir"
  [[ -e "$to" || -h "$to" ]] || ln -s "$from" "$to"
}

[[ -d $DOTDEST ]] || mkdir -p "$DOTDEST"

(cd ${DOTROOT} && git ls-files) | while read item; do
  is-member-of "${item}" "${EXCLUDED_PATTERNS[@]}" || make-link "$item"
done
