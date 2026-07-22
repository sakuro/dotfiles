#!/bin/bash

# Don't use long command line options in this script.

: "${DOTROOT:=$HOME/.dotfiles}"
: "${DOTDEST:=$HOME}"

EXCLUDED_PATHSPECS=(
  ':!/Makefile'
  ':!/README.md'
  ':!/files/'
  ':!/scripts/'
  ':!/.gitignore'
  ':!/.gitmodules'
  ':!/renovate.json'
)

case "$OSTYPE" in
darwin*)
  ;;
*)
  EXCLUDED_PATHSPECS+=(':!/Library/')
  ;;
esac

[[ -d "$DOTDEST" ]] || mkdir -p "$DOTDEST"

(cd "$DOTROOT" && git ls-files . "${EXCLUDED_PATHSPECS[@]}") | while read -r file; do
  from="$DOTROOT/${file}"
  to="$DOTDEST/${file}"
  dir="$(dirname "$file")"

  [[ "$dir" = "." ]] || [[ -d "$DOTDEST/$dir" ]] || mkdir -p "$DOTDEST/$dir"
  [[ -e "$to" || -h "$to" ]] || ln -sv "$from" "$to"
done

# Remove dangling symlinks, and any directory left empty by that removal.
#
# Scoped to symlinks whose target lives under $DOTROOT (i.e. links this
# script itself could have created), found only within .config and bin,
# and pruning walks upward only from the removed link's own directory.
# This must not widen into a blanket sweep of $DOTDEST/.config: live
# application state can share a directory with dotfiles-managed files
# (e.g. Claude Code keeps its own runtime data alongside CLAUDE.md under
# .config/claude), and a recursive "delete every empty dir" pass would
# destroy it.
prune_empty_ancestors() {
  local dir="$1"
  while [[ "$dir" == "$DOTDEST/.config/"* || "$dir" == "$DOTDEST/bin/"* ]] && rmdir "$dir" 2>/dev/null; do
    echo "rmdir: removing directory, '$dir'"
    dir="$(dirname "$dir")"
  done
}

while read -r link; do
  [[ -e "$link" ]] && continue
  rm -v "$link"
  prune_empty_ancestors "$(dirname "$link")"
done < <(find "$DOTDEST/.config" "$DOTDEST/bin" -type l -lname "$DOTROOT/*" 2>/dev/null)

# Handle .config/git/include/credentials
CREDENTIAL_CONFIG_FILE="$DOTDEST/.config/git/include/credential"
if [[ ! -f "$CREDENTIAL_CONFIG_FILE" ]]; then
  case "$OSTYPE" in
  darwin*)
    ln -sv "$DOTROOT/.config/git/include/credential.darwin" "$CREDENTIAL_CONFIG_FILE"
    ;;
  linux*)
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
      if [[ -x "/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager.exe" ]]; then
        ln -sv "$DOTROOT/.config/git/include/credential.windows" "$CREDENTIAL_CONFIG_FILE"
      fi
    fi
    ;;
  esac
fi
