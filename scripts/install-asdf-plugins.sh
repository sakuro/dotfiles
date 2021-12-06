#!/bin/bash

TOOL_VERSIONS_FILE=$HOME/.tool-versions

if [[ -f $TOOL_VERSIONS_FILE ]]; then
  source /opt/homebrew/opt/asdf/libexec/asdf.sh
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
else
  echo "${TOOL_VERSIONS_FILE/$HOME/~/} does not exist"
fi
