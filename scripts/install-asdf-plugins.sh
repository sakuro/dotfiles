#!/bin/bash

TOOL_VERSIONS_FILE=$XDG_CONFIG_HOME/asdf/tool-versions

function init_asdf()
{
  local asdf_sh
  for asdf_sh in /opt/homebrew/opt/asdf/libexec/asdf.sh $HOME/.asdf/asdf.sh; do
    source $asdf_sh
    return 0
  done
  return 1
}

init_asdf || {
  echo "ASDF is not installed"
  exit 1
}

[[ -f $TOOL_VERSIONS_FILE ]] || {
  echo "${TOOL_VERSIONS_FILE/$HOME/~/} does not exist"
  exit 0
}

while read plugin version; do
  if asdf plugin list | grep -qxF $plugin; then
    echo "Updating plugin: $plugin"
    asdf plugin-update $plugin
  else
    echo "Installing plugin: $plugin"
    asdf plugin-add $plugin
  fi
  if asdf list $plugin | grep -qxF $version; then
    echo "$plugin $version is already installed"
  else
    echo "Installing $plugin $version"
    asdf install $plugin $version
  fi
done < $TOOL_VERSIONS_FILE
