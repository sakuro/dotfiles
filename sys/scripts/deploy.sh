#!/bin/bash

. $(dirname $0)/defs.sh


function list_targets() {

  (cd ${DOTROOT} && git ls-files) | while read item; do
    is_member_of "${item}" "${EXCLUDED_PATTERNS[@]}" || echo "${item}"
  done
}

function make_link() {
  local file="$1"

  local from="$DOTROOT/${file}"
  local to="$DOTDEST/${file}"
  local dir="$(dirname "$file")"

  [[ "dir" = "." ]] || [[ -d "$DOTDEST/$dir" ]] || mkdir_p "$DOTDEST/$dir"
  if [[ -e "$to" ]]; then
    echo "${to} already exists"
  else
    ln_s "$from" "$to"
  fi
}

[[ -d $DOTDEST ]] || mkdir_p "$DOTDEST"

list_targets | while read file; do
  make_link "$file"
done
