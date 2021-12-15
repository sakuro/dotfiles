#!/bin/bash

: "${DOTROOT:?} "${DOTDEST:?}

EXCLUDED_PATTERNS=(
  Brewfile*
  Makefile
  README.md
  bootstrap.sh
  scripts/*
  sys/*
  .gitignore
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
  [[ -e "$to" || -h "$to" ]] || ln -sv "$from" "$to"
}

[[ -d $DOTDEST ]] || mkdir -p "$DOTDEST"

(cd ${DOTROOT} && git ls-files) | while read item; do
  is-member-of "${item}" "${EXCLUDED_PATTERNS[@]}" || make-link "$item"
done

# Remove dangling symlinks
GLOBIGNORE=.git:scripts
for dir in $(cd ${DOTROOT} && find * -maxdepth 0 -type d); do
  find $DOTDEST/$dir -xtype l -exec rm -v '{}' +
done

# Handle .config/git/include/credentials
case $OSTYPE in
darwin*)
  ln -svf $DOTROOT/.config/git/include/credential.darwin $DOTDEST/.config/git/include/credential
  ;;
linux*)
  if [[ -n "$WSL_DISTRO_NAME" ]]; then
    if [[ -x "/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager.exe" ]]; then
      ln -svf $DOTROOT/.config/git/include/credential.windows $DOTDEST/.config/git/include/credential
    fi
  fi
  ;;
esac
