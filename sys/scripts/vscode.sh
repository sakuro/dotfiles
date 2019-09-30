#!/bin/bash

EXTENSIONS=(
  arcticicestudio.nord-visual-studio-code
  bierner.github-markdown-preview
  castwide.solargraph
  deerawan.vscode-dash
  EditorConfig.EditorConfig
  mauve.terraform
  MS-CEINTL.vscode-language-pack-ja
)

for extension in "${EXTENSIONS[@]}"; do
  code --install-extension "${extension}"
done
