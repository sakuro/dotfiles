#!/bin/bash

case "${OSTYPE}" in
darwin*)
  echo darwin
  ;;
*linux*)
  # shellcheck disable=SC1091
  source /etc/os-release
  for id in "${ID}" "${ID_LIKE}"; do
    case "${id}" in
    debian)
      echo linux-debian
      exit 0
      ;;
    esac
  done
  echo "Unsupported Linux: ${ID} / ${PRETTY_NAME}" 1>&2
  exit 1
  ;;
*)
  echo "Unsupported OS: ${OSTYPE}"
  exit 1
  ;;
esac
