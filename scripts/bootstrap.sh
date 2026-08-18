#!/usr/bin/env bash

BOOTSTRAP_TOML_URL="https://dot.2238.club/.config/mise/bootstrap.toml"
DOTROOT="$HOME/.dotfiles"
PATH="$HOME/bin:$PATH"

set -euo pipefail

curl -fsSL https://mise.run | MISE_INSTALL_PATH="$HOME/bin/mise" bash

bootstrap_config="$(mktemp)"
trap 'rm -f "$bootstrap_config"' EXIT

curl -fsSL -o "$bootstrap_config" "${BOOTSTRAP_TOML_URL}"
MISE_GLOBAL_CONFIG_FILE="$bootstrap_config" mise bootstrap repos apply

#$DOTROOT/scripts/link-dotfiles.sh"
#mise bootstrap apply
