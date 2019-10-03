#!/bin/bash

. $(dirname $0)/../dotfiles.sh

TOOL_VERSIONS_FILE="${HOME}/.tool-versions"

if is-executable asdf; then
  :
else
  echo 'asdf is not installed'
  exit 0
fi

if [[ -f "${TOOL_VERSIONS_FILE}" ]]; then
  :
else
  echo "${TOOL_VERSIONS_FILE/$HOME/~/} does not exist"
  exit 0
fi

PLUGINS=( $(awk '{print $1}' "${TOOL_VERSIONS_FILE}") )

for plugin in "${PLUGINS[@]}"; do
  asdf plugin-add "${plugin}"
done
