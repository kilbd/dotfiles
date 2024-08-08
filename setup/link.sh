#!/bin/env bash

set -e

link_dotfile () {
  relative=$(realpath --relative-to="$HOME/dotfiles" "$1")
  target="$HOME/$relative"
  backup="$HOME/dotfiles-backup"
  if [ -e "$target" ]; then
    # copy dotfile to backup if it's a real file (not link), otherwise delete
    if [ -f "$target" ] && [ ! -L "$target" ]; then
      backup_target="$backup/$relative"
      backup_dir="$(dirname "$backup_target")"
      if [ ! -d "$backup_dir" ]; then
        mkdir -p "$backup_dir"
      fi
      mv "$target" "$backup_target"
    else
      rm "$target"
    fi
  fi
  echo "Creating link for $relative."
  target_dir="$(dirname "$target")"
  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
  fi
  ln -s "$1" "$target"
}

export -f link_dotfile

find "$HOME/dotfiles" -type f -not -path '*/\.git/*' -not -path '*/setup/*' \
  -not -path '*README*' -print0 | xargs -0 -I {} bash -c 'link_dotfile "$@"' _ {}

