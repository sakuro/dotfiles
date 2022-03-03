#!/bin/bash

TOOL_VERSIONS_FILE=$XDG_CONFIG_HOME/asdf/tool-versions

function init_asdf()
{
  local asdf_sh
  for asdf_sh in /opt/homebrew/opt/asdf/libexec/asdf.sh $HOME/.asdf/asdf.sh; do
    # shellcheck disable=SC1090
    source "$asdf_sh"
    return 0
  done
  return 1
}

function install_or_update_plugin()
{
  local plugin=$1

  if asdf plugin list | grep --quiet --line-regexp --fixed-strings "$plugin"; then
    echo "Updating plugin: $plugin"
    asdf plugin-update "$plugin"
  else
    echo "Installing plugin: $plugin"
    asdf plugin-add "$plugin"
  fi
  return 0
}

function install_specific_version()
{
  plugin=$1
  version=$2

  if asdf list "$plugin" | grep --quiet --line-regexp --fixed-strings "$version"; then
    echo "$plugin $version is already installed"
  else
    echo "Installing $plugin $version"
    asdf install "$plugin" "$version"
  fi
}

init_asdf || {
  echo "ASDF is not installed"
  exit 1
}

[[ -f "$TOOL_VERSIONS_FILE" ]] || {
  echo "${TOOL_VERSIONS_FILE/$HOME/~/} does not exist"
  exit 0
}

while read -r plugin version; do
  install_or_update_plugin "$plugin" && install_specific_version "$plugin" "$version"
done < "$TOOL_VERSIONS_FILE"
