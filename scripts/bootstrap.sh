#!/usr/bin/env bash

set -euo pipefail

BOOTSTRAP_TOML_URL="https://dot.2238.club/.config/mise/config.toml"
DOTROOT="$HOME/.dotfiles"
PATH="$HOME/bin:$PATH"

case "$(uname)" in
Darwin) OS=macos ;;
Linux) OS=linux ;;
*) echo "Unsupported OS"; exit 1 ;;
esac

curl -fsSL https://mise.run | MISE_INSTALL_PATH="$HOME/bin/mise" bash
eval "$(mise activate)"

bootstrap_config_dir="$(mktemp -d)"
trap 'rm -rf "$bootstrap_config_dir"' EXIT

export MISE_GLOBAL_CONFIG_FILE="${bootstrap_config_dir}/config.toml"
curl -fsSL -o "${MISE_GLOBAL_CONFIG_FILE}" "${BOOTSTRAP_TOML_URL}"
curl -fsSL "${BOOTSTRAP_TOML_URL/.toml/.${OS}.toml}" >> "${MISE_GLOBAL_CONFIG_FILE}"
mise bootstrap --yes
