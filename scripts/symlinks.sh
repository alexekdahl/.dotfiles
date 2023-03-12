#!/bin/bash

# Specify the dotfiles and their corresponding paths
dotfiles=(
  "yabai/yabairc:~/.config/yabai/yabairc"
  "skhd/skhdrc:~/.config/skhd/skhdrc"
  "p10k/p10k.zsh:~/.p10k.zsh"
  "zsh/.zshrc:~/.zshrc"
  "nvim/lua:~/.config/nvim/lua"
  "nvim/init.vim:~/.config/nvim/init.vim"
)

# Loop through each dotfile and create a symlink
for dotfile in "${dotfiles[@]}"; do
  src=$(echo "$dotfile" | cut -d':' -f1)
  dest=$(echo "$dotfile" | cut -d':' -f2)
  src_path="$HOME/.dotfiles/$src"
  dest_path="$HOME/$dest"

  # Check if the destination file already exists and is not a symlink
  if [ -f "$dest_path" ] && [ ! -L "$dest_path" ]; then
    echo "Backing up existing file at $dest_path..."
    mv "$dest_path" "$dest_path.bak"
  fi

  # Create the symlink
  echo "Creating symlink for $src_path at $dest_path..."
  ln -sf "$src_path" "$dest_path"
done
