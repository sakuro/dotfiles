#!/bin/zsh

for file in $HOME/.zsh.d/zshrc/*(.); do
  source $file
done
