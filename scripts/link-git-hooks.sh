#!/usr/bin/env bash

if [[ -f $HOME/.dotfiles/.git/hooks/post-merge ]]; then
  exit 0
fi

mkdir -p $HOME/.dotfiles/.git/hooks
ln -s -v "$HOME/.dotfiles/scripts/post-merge" "$HOME/.dotfiles/.git/hooks/post-merge"
