#!/bin/zsh

defaults write org.hammerspoon.Hammerspoon MJConfigFile ~/.config/hammerspoon/init.lua
defaults write org.hammerspoon.Hammerspoon input-methods '{"en" = "英字　　（ATOK）"; "ja" = "ひらがな（ATOK）";}'

if [[ -f $HOME/.hammerspoon/init.lua ]]; then
  rm --verbose $HOME/.hammerspoon/init.lua
fi

if [[ -d $HOME/.hammerspoon ]]; then
  rmdir --verbose --parents $HOME/.hammerspoon
fi
