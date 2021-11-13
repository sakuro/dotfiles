#!/bin/bash

TOOL_VERSIONS_FILE="${HOME}/.tool-versions"
PLUGINS=( $(awk '{print $1}' "${TOOL_VERSIONS_FILE}") )

type -P asdf > /dev/null && exit 0
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf

if [[ -f "${TOOL_VERSIONS_FILE}" ]]; then
  source $HOME/.asdf/asdf.sh
  for plugin in "${PLUGINS[@]}"; do
    echo "Installing plugin: ${plugin}"
    asdf plugin-add "${plugin}"
  done
else
  echo "${TOOL_VERSIONS_FILE/$HOME/~/} does not exist"
fi
