#!/bin/bash

VERSION_RE='^[0-9]+(\.[0-9]+)+$'
TOOL_VERSIONS_FILE="${HOME}/.tool-versions"

new_file="$(mktemp)"
exec < "${TOOL_VERSIONS_FILE}"
exec > "${new_file}"

while read plugin_name old_version; do
  if asdf plugin-list | grep -q '^'"${plugin_name}"'$'; then
    asdf plugin-update "${plugin_name}" >&2
  else
    asdf plugin-add "${plugin_name}" >&2
  fi
  new_version="$(asdf list-all "${plugin_name}" 2>/dev/null | grep -E "${VERSION_RE}" | sed -ne '$p')"
  echo "${plugin_name}" "${new_version}"
done

diff -q "${new_file}" "${TOOL_VERSIONS_FILE}" >/dev/null && exit 0
cat "${new_file}" > "${TOOL_VERSIONS_FILE}"
