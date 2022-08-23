#!/bin/bash

source $(dirname "${BASH_SOURCE:-$0}")/util.sh

function update-packages-darwin()
{
  brew upgrade --verbose
}

function update-packages-linux-debian()
{
  sudo apt update && sudo apt --yes upgrade
}

update-packages-$(os)
