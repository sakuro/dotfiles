#!/bin/zsh

local_brewfile="Brewfile.$(hostname)"

[[ -f $local_brewfile ]] || exit 0

setopt nullglob nonomatch
old_brewfiles=($local_brewfile.<-> )
for b in ${(On)old_brewfiles}; do
  mv -v $b ${b:r}.$((${b:e} + 1))
done
mv -v $local_brewfile $local_brewfile.1
