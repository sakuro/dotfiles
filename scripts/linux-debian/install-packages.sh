#!/bin/bash

if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

PATH=$HOME/.local/bin:$PATH
MISE_AUTO_ENV=true mise bootstrap packages apply --yes

sudo apt install --yes locales
sudo sed -i -e '/ja_JP.UTF-8/s/^# *//' /etc/locale.gen
sudo locale-gen --keep-existing

mise install
