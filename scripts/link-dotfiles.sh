#!/bin/bash

: "${DOTROOT:=$HOME/.dotfiles}"
: "${DOTDEST:=$HOME}"

EXCLUDED_PATHSPECS=(
  ':!/Brewfile'
  ':!/Makefile'
  ':!/README.md'
  ':!/bootstrap.sh'
  ':!/scripts/'
  ':!/*.txt'
  ':!/.gitignore'
  ':!/.gitmodules'
)

[[ -d "$DOTDEST" ]] || mkdir --parents "$DOTDEST"

(cd "$DOTROOT" && git ls-files . "${EXCLUDED_PATHSPECS[@]}") | while read -r file; do
  from="$DOTROOT/${file}"
  to="$DOTDEST/${file}"
  dir="$(dirname "$file")"

  [[ "$dir" = "." ]] || [[ -d "$DOTDEST/$dir" ]] || mkdir --parents "$DOTDEST/$dir"
  [[ -e "$to" || -h "$to" ]] || ln --symbolic --verbose "$from" "$to"
done

# Remove dangling symlinks
for dir in $(cd "$DOTROOT" && find ./* -maxdepth 0 -type d); do
  [[ -d $DOTDEST/$dir ]] && find "$DOTDEST/$dir" -xtype l -exec rm --verbose '{}' +
done

# Handle .config/git/include/credentials
CREDENTIAL_CONFIG_FILE="$DOTDEST/.config/git/include/credential"
if [[ ! -f "$CREDENTIAL_CONFIG_FILE" ]]; then
  case "$OSTYPE" in
  darwin*)
    ln --symbolic --verbose "$DOTROOT/.config/git/include/credential.darwin" "$CREDENTIAL_CONFIG_FILE"
    ;;
  linux*)
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
      if [[ -x "/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager.exe" ]]; then
        ln --symbolic --verbose "$DOTROOT/.config/git/include/credential.windows" "$CREDENTIAL_CONFIG_FILE"
      fi
    fi
    ;;
  esac
fi
