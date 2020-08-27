#!/bin/bash

. $(dirname $0)/../dotfiles.sh

VERSION=v0.8.0-rc1
TOOL_VERSIONS_FILE="${HOME}/.tool-versions"
PLUGINS=( $(awk '{print $1}' "${TOOL_VERSIONS_FILE}") )

if is-executable asdf; then
  echo 'asdf is already installed'
else
  echo 'Installing asdf'
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  cd ~/.asdf
  git checkout "$(git describe --abbrev=0 --tags)"
fi

if [[ -f "${TOOL_VERSIONS_FILE}" ]]; then
  source ~/.asdf/asdf.sh
  for plugin in "${PLUGINS[@]}"; do
    echo "Installing plugin: ${plugin}"
    asdf plugin-add "${plugin}"
  done
else
  echo "${TOOL_VERSIONS_FILE/$HOME/~/} does not exist"
fi


