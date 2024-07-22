#!/bin/env bash
set -e

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt install -y libssl-dev openssl pkg-config build-essential git curl wget neovim

# Install Rust(up)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Rust tools
cargo install bat difftastic eza ripgrep zellij
cargo install --locked --bin jj jj-cli

# Clone dotfiles as a bare repository
git clone --bare https://github.com/kilbd/dotfiles.git $HOME/.dotfiles
function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME $@
}
dotfiles checkout
# Move pre-existing dotfiles if there was an error
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
else
  echo "Backing up pre-existing dotfiles.";
  mkdir -p .dotfiles-backup
  dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi

dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

