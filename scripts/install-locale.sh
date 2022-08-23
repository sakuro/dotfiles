#!/bin/bash

source $(dirname "${BASH_SOURCE:-0}")/util.sh

function install-locale-darwin()
{
  # do nothing
}

function install-locale-linux-debian()
{
  sudo apt install --yes locales
  sudo sed -i -e '/ja_JP.UTF-8/s/^# *//' /etc/locale.gen
  sudo locale-gen --keep-existing
}

install-locale-$(os)
