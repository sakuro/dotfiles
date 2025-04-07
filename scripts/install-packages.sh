#!/bin/bash

source $(dirname "${BASH_SOURCE:-$0}")/util.sh

function install-packages-darwin()
{
  eval "$(/usr/libexec/path_helper)"
  PATH=/opt/homebrew/bin:$PATH
  [[ -x /opt/homebrew/bin/brew ]] || scripts/install-homebrew.sh
  brew bundle --no-lock
  chmod go-w "$(brew --prefix)/share"
}

function install-packages-linux-debian()
{
  install-source-list
  sudo apt update
  # shellcheck disable=SC2046
  sudo apt install --yes $(cat apt-packages.txt)
}

funciton install-signing-key()
{
  local name="$1"
  local url="$2"
  local key_file="/usr/share/keyrings/$name.gpg"

  [[ -f "$key_file" ]] || curl -fsSL "$url" | sudo gpg --dearmor -o "$key_file"
}

function install-apt-line()
{
  local name="$1"
  local url="$2"
  local apt_file="/etc/apt/sources.list.d/$name.list"
  local key_file="/usr/share/keyrings/$name.gpg"
  local arch="$(dpkg --print-architecture)"

  [[ -f "$apt_file" ]] || echo "deb [arch=$arch signed-by=$key_file] $url stable main" | sudo tee "$apt_file"
}

function install-source-list()
{
  sudo apt update
  sudo apt install -y apt-transport-https ca-certificates curl

  sudo install -dm 755 /usr/share/keyrings
  sudo install -dm 755 /etc/apt/sources.list.d

  # GitHub CLI
  install-signing-key "github-cli" "https://cli.github.com/packages/githubcli-archive-keyring.gpg"
  install-apt-line "github-cli" "https://cli.github.com/packages"

  # mise-en-place
  install-signing-key "mise" "https://mise.jdx.dev/gpg-key.pub"
  install-apt-line "mise" "https://mise.jdx.dev/deb"

  # kubectl
  install-signing-key "kubernetes" "https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key"
  install-apt-line "kubernetes" "https://pkgs.k8s.io/core:/stable:/v1.30/deb/"
}

install-packages-$(os)
