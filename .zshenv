#!/bin/zsh

for file in $HOME/.zsh.d/zshenv/*(x.); do
  source $file
done
