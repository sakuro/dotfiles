#!/bin/sh

git -C .config/wezterm/wezterm config core.sparsecheckout true
mkdir --parents .git/modules/.config/wezterm/wezterm/info
cat <<CONTENT > .git/modules/.config/wezterm/wezterm/info/sparse-checkout
/assets/shell-integration/wezterm.sh
CONTENT
git -C .config/wezterm/wezterm read-tree -mu HEAD
