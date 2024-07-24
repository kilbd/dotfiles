#!/bin/env bash
set -e

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt install -y libssl-dev openssl ca-certificates pkg-config \
  build-essential git curl wget neovim

# Install Rust(up)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --quiet
. "$HOME/.cargo/env"

# Install Rust tools
cargo install bat difftastic eza nu ripgrep zellij
cargo install --locked --bin jj jj-cli

# Install Node (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker ${USER}

# Clone full dotfiles repo if missing
git ls-remote -q "$HOME/dotfiles" > /dev/null 2>&1
if [[ "$?" -ne 0 ]]; then
  git clone https://github.com/kilbd/dotfiles.git "$HOME/dotfiles"
fi

echo 'Linking dotfiles...'
source "$HOME/dotfiles/setup/link.sh"

