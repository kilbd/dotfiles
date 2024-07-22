#!/bin/env bash
set -e

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt install -y libssl-dev openssl pkg-config build-essential git curl wget neovim

# Install Rust(up)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"

# Install Rust tools
cargo install bat difftastic eza ripgrep zellij
cargo install --locked --bin jj jj-cli

# Clone dotfiles as a bare repository
git clone --bare https://github.com/kilbd/dotfiles.git "$HOME/.dotfiles"
function dotfiles {
   /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

set +e
# Move pre-existing dotfiles if error checking out
if dotfiles checkout; then
  echo "Checked out dotfiles.";
else
  echo "Backing up pre-existing dotfiles.";
  mkdir -p .dotfiles-backup
  dotfiles checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} .dotfiles-backup/{}
fi
set -e

dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

