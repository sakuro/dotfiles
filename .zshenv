#!/bin/zsh

fpath=(~/.zsh.d/*(/N) $fpath)
autoload ${(e)${^$(echo ~/.zsh.d/functions/*(.N))}:t}

typeset -aU path
set -A path ${^${~${(@fe)"$(<~/.zsh.d/paths)"}}}(N)

ulimit -c unlimited
umask 022

unset LC_ALL
export LANG=ja_JP.UTF-8
export LC_TIME=C LC_MESSAGES=C
export TIME_STYLE=long-iso
export _JAVA_OPTIONS=-Dfile.encoding=UTF-8

# dlopen's search path
export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/lib
