#!/bin/bash

: "${DOTROOT:=$HOME/.dotfiles}"
: "${DOTDEST:=$HOME}"

EXCLUDED_PATHSPECS=(
  ':!/Brewfile'
  ':!/Makefile'
  ':!/README.md'
  ':!/bootstrap.sh'
  ':!/scripts/'
  ':!/.gitignore'
  ':!/.gitmodules'
)

[[ -d $DOTDEST ]] || mkdir -p "$DOTDEST"

(cd ${DOTROOT} && git ls-files . ${EXCLUDED_PATHSPECS[@]}) | while read file; do
  from="$DOTROOT/${file}"
  to="$DOTDEST/${file}"
  dir="$(dirname "$file")"

  [[ "{$dir}" = "." ]] || [[ -d "$DOTDEST/$dir" ]] || mkdir -p "$DOTDEST/$dir"
  [[ -e "$to" || -h "$to" ]] || ln -sv "$from" "$to"
done

# Remove dangling symlinks
GLOBIGNORE=.git:scripts
for dir in $(cd ${DOTROOT} && find * -maxdepth 0 -type d); do
  find $DOTDEST/$dir -xtype l -exec rm -v '{}' +
done

# Handle .config/git/include/credentials
CREDENTIAL_CONFIG_FILE=$DOTDEST/.config/git/include/credential
if [[ ! -f $CREDENTIAL_CONFIG_FILE ]]; then
  case $OSTYPE in
  darwin*)
    ln -sv $DOTROOT/.config/git/include/credential.darwin $CREDENTIAL_CONFIG_FILE
    ;;
  linux*)
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
      if [[ -x "/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager.exe" ]]; then
        ln -sv $DOTROOT/.config/git/include/credential.windows $CREDENTIAL_CONFIG_FILE
      fi
    fi
    ;;
  esac
fi
