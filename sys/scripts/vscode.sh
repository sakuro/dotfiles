#!/bin/bash

EXTENSIONS=(
  arcticicestudio.nord-visual-studio-code
  bierner.github-markdown-preview
  castwide.solargraph
  deerawan.vscode-dash
  EditorConfig.EditorConfig
  mauve.terraform
  MS-CEINTL.vscode-language-pack-ja
  ms-vscode-remote.remote-containers
)

for extension in "${EXTENSIONS[@]}"; do
  code --list-extensions | grep -qF "${extension}" || code --install-extension "${extension}"
done
