#!/bin/bash

nvim_lua_path="$HOME/.config/nvim/lua"
nvim_ftplugin_path="$HOME/.config/nvim/after/ftplugin"
nvim_go_path="$HOME/.config/nvim/after/ftplugin/go.vim"
alacritty_path="$HOME/.config/alacritty"
i3_path="$HOME/.config/i3"
picom_path="$HOME/.config/picom"
polybar_path="$HOME/.config/polybar"
rofi_path="$HOME/.config/rofi"

zshrc_link="$HOME/.dotfiles/zsh/.zshrc"
p10k_link="$HOME/.dotfiles/p10k/p10k.zsh"
nvim_link="$HOME/.dotfiles/nvim/init.vim"

nvim_lua_link="$HOME/.dotfiles/nvim/lua/"
alacritty_link="$HOME/.dotfiles/alacritty/"
i3_link="$HOME/.dotfiles/i3/"
picom_link="$HOME/.dotfiles/picom/"
rofi_link="$HOME/.dotfiles/rofi/"

# Create necessary directories
mkdir -p "$nvim_lua_path" "$nvim_ftplugin_path" "$alacritty_path" "$i3_path" "$picom_path" "$polybar_path" "$rofi_path"

# Backup function
backup_if_exists() {
    local target_file=$1
    if [ -f "$target_file" ]; then
        cp "$target_file" "$target_file.old"
    fi
}

# Backup and symlink
backup_if_exists "$HOME/.zshrc"
ln -s "$zshrc_link" "$HOME/.zshrc"

backup_if_exists "$HOME/.p10k.zsh"
ln -s "$p10k_link" "$HOME/.p10k.zsh"

backup_if_exists "$HOME/.config/nvim/init.vim"
ln -s "$nvim_link" "$HOME/.config/nvim/init.vim"

# Symlink entire folders
ln -sf "$nvim_lua_link" "$nvim_lua_path"
ln -sf "$alacritty_link" "$alacritty_path"
ln -sf "$i3_link" "$i3_path"
ln -sf "$picom_link" "$picom_path"
ln -sf "$polybar_link" "$polybar_path"
ln -sf "$rofi_link" "$rofi_path"

# Add content to vim go file
echo -e "setlocal shiftwidth=4\nsetlocal tabstop=4" > "$nvim_go_path"
