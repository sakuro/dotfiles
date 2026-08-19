#!/usr/bin/env bash

if [[ -f .git/hooks/post-merge ]]; then
  exit 0
fi

mkdir -p .git/hooks
ln -s -v "$PWD/scripts/post-merge" .git/hooks/post-merge
