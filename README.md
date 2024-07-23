# dotfiles

My collection of configs for moving between (usually Linux) machines.

## Installation

On a fresh Ubuntu install, you can install desired packages and create links to configs in this repository (cloned to `~/dotfiles`). To run the setup script, copy-paste this command to your Ubuntu terminal:

```shell
sudo curl -Lks https://raw.githubusercontent.com/kilbd/dotfiles/main/setup/ubuntu.sh | bash
```

## New Config Files

Whenever you add a new configuration file to this repo, you can add the link with the `setup/link.sh` script:

```shell
source setup/link.
```

This script also copies any existing configuration to a backup folder before overwriting it.

