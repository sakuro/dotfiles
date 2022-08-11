#!/bin/sh

function os()
{
  case "${OSTYPE}" in
  darwin*)
    echo darwin
    ;;
  *linux*)
    echo "linux-$(linux-release)"
    ;;
  *)
    echo "Unsupported OS: ${OSTYPE}"
    return 1
    ;;
  esac
}

function linux-release()
{
    # shellcheck disable=SC1091
    source /etc/os-release

    for id in "${ID}" "${ID_LIKE}"; do
        case "${id}" in
        debian)
            echo debian
            return 0
            ;;
        esac
    done

    echo "Unsupported Linux: ${ID} / ${PRETTY_NAME}" 1>&2
    return 1
}
