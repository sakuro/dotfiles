#!/bin/bash

VERSION=v0.8.1
TOOL_VERSIONS_FILE="${HOME}/.tool-versions"
PLUGINS=( $(awk '{print $1}' "${TOOL_VERSIONS_FILE}") )

if type -P asdf > /dev/null; then
  echo 'asdf is already installed'
else
  echo 'Installing asdf'
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  (cd $HOME/.asdf && git checkout "$(git describe --abbrev=0 --tags)")
fi

if [[ -f "${TOOL_VERSIONS_FILE}" ]]; then
  source $HOME/.asdf/asdf.sh
  for plugin in "${PLUGINS[@]}"; do
    echo "Installing plugin: ${plugin}"
    asdf plugin-add "${plugin}"
  done
else
  echo "${TOOL_VERSIONS_FILE/$HOME/~/} does not exist"
fi
