#!/bin/env bash
set -e

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt install -y libssl-dev openssl pkg-config build-essential git curl wget neovim

# Install Rust(up)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --quiet
. "$HOME/.cargo/env"

# Install Rust tools
cargo install bat difftastic eza ripgrep zellij
cargo install --locked --bin jj jj-cli

# Clone full dotfiles repo
git clone https://github.com/kilbd/dotfiles.git "$HOME/dotfiles"

echo 'Linking dotfiles...'
source "$HOME/dotfiles/setup/link.sh"

