#!/bin/bash

# shellcheck disable=SC2046
sudo apt install --yes $(cat files/apt-packages.txt)

sudo apt install --yes locales
sudo sed -i -e '/ja_JP.UTF-8/s/^# *//' /etc/locale.gen
sudo locale-gen --keep-existing

curl https://mise.run | sh

PATH=$HOME/.local/bin:$PATH
mise install
