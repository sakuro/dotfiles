#!/bin/zsh

for file in $HOME/.zsh.d/zshrc/*(x.); do
  source $file
done
