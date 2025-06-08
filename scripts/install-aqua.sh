#!/bin/bash

source $(dirname "${BASH_SOURCE:-$0}")/util.sh

function install-aqua-darwin()
{
  brew install aqua
}

function install-aqua-linux-debian()
{
  # Bootstrap the installation of Aqua using specific version of aqua-installer
  # https://aquaproj.github.io/docs/products/aqua-installer/bootstrap
  AQUA_INSTALLER_VERSION=v3.1.2
  AQUA_INSTALLER_URL=https://raw.githubusercontent.com/aquaproj/aqua-installer/${AQUA_INSTALLER_VERSION}/aqua-installer

  aqua_installer_tmp_dir=$(mktemp -d)
  trap "test -d $aqua_installer_tmp_dir && rm -rf $aqua_installer_tmp_dir" EXIT

  cd $aqua_installer_tmp_dir

  curl -sSfL ${AQUA_INSTALLER_URL}
  echo "9a5afb16da7191fbbc0c0240a67e79eecb0f765697ace74c70421377c99f0423  aqua-installer" | sha256sum -c -
  chmod +x aqua-installer
  ./aqua-installer

  PATH=$HOME/.local/share/aquaproj-aqua/bin:$PATH
  aqua update-aqua
  aqua install -a
}

install-aqua-$(os)
