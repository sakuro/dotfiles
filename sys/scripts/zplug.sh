#!/bin/bash

. $(dirname $0)/../dotfiles.sh

ZPLUG_HOME=$XDG_CONFIG_HOME/zsh/plugins/zplug

if is-executable zplug; then
  echo 'zplug is already installed'
else
  echo 'Installing zplug'
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi
