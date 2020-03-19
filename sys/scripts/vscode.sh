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

VSCODE=${VSCODE:=code}

for extension in "${EXTENSIONS[@]}"; do
  "${VSCODE}" --list-extensions | grep -qF "${extension}" || "${VSCODE}" --install-extension "${extension}"
done
