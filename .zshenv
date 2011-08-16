#!/bin/zsh

for file in $HOME/.zsh.d/zshenv/*(.); do
  source $file
done
