#!/bin/bash

source $(dirname "${BASH_SOURCE:-$0}")/util.sh

function clean-packages-darwin()
{
	brew cleanup --prune=all
}

function clean-packages-linux-debian()
{
  sudo apt autoremove
}

clean-packages-$(os)
