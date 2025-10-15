#!/usr/bin/env bash

set -e

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/Brewfile"
ZSH_DIR="$HOME/.zsh"

# Install Homebrew packages
if [[ -f "$BREWFILE" ]]; then
    echo "Installing Homebrew packages from Brewfile..."
    brew bundle install --file="$BREWFILE"
else
    echo "Warning: Brewfile not found at $BREWFILE"
fi

# Install zsh plugins
echo "Installing zsh plugins..."
mkdir -p "$ZSH_DIR"

if [[ -d "$ZSH_DIR/zsh-defer" ]]; then
    echo "Updating zsh-defer..."
    cd "$ZSH_DIR/zsh-defer" && git pull
else
    echo "Installing zsh-defer..."
    git clone --depth=1 https://github.com/romkatv/zsh-defer.git "$ZSH_DIR/zsh-defer"
fi

if [[ -d "$ZSH_DIR/zsh-autosuggestions" ]]; then
    echo "Updating zsh-autosuggestions..."
    cd "$ZSH_DIR/zsh-autosuggestions" && git pull
else
    echo "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_DIR/zsh-autosuggestions"
fi

if [[ -d "$ZSH_DIR/zsh-syntax-highlighting" ]]; then
    echo "Updating zsh-syntax-highlighting..."
    cd "$ZSH_DIR/zsh-syntax-highlighting" && git pull
else
    echo "Installing zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_DIR/zsh-syntax-highlighting"
fi

# Create symlinks
echo "Creating symlinks..."

# Symlink .zshrc
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    echo "Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

if [[ -L "$HOME/.zshrc" ]]; then
    rm "$HOME/.zshrc"
fi

ln -s "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
echo "Created symlink: ~/.zshrc -> $DOTFILES/zsh/.zshrc"

# Symlink .p10k.zsh
if [[ -f "$HOME/.p10k.zsh" && ! -L "$HOME/.p10k.zsh" ]]; then
    echo "Backing up existing .p10k.zsh to .p10k.zsh.backup"
    mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup"
fi

if [[ -L "$HOME/.p10k.zsh" ]]; then
    rm "$HOME/.p10k.zsh"
fi

ln -s "$DOTFILES/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
echo "Created symlink: ~/.p10k.zsh -> $DOTFILES/p10k/.p10k.zsh"

# Create tmux config directory
mkdir -p "$HOME/.config/tmux"

# Symlink tmux.conf
if [[ -f "$HOME/.config/tmux/tmux.conf" && ! -L "$HOME/.config/tmux/tmux.conf" ]]; then
    echo "Backing up existing tmux.conf to tmux.conf.backup"
    mv "$HOME/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf.backup"
fi

if [[ -L "$HOME/.config/tmux/tmux.conf" ]]; then
    rm "$HOME/.config/tmux/tmux.conf"
fi

ln -s "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
echo "Created symlink: ~/.config/tmux/tmux.conf -> $DOTFILES/tmux/tmux.conf"

# Symlink modules directory
if [[ -d "$HOME/.config/tmux/modules" && ! -L "$HOME/.config/tmux/modules" ]]; then
    echo "Backing up existing modules directory to modules.backup"
    mv "$HOME/.config/tmux/modules" "$HOME/.config/tmux/modules.backup"
fi

if [[ -L "$HOME/.config/tmux/modules" ]]; then
    rm "$HOME/.config/tmux/modules"
fi

ln -s "$DOTFILES/tmux/modules" "$HOME/.config/tmux/modules"
echo "Created symlink: ~/.config/tmux/modules -> $DOTFILES/tmux/modules"

# Install TPM (Tmux Plugin Manager)
echo "Installing TPM (Tmux Plugin Manager)..."
TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    echo "Updating TPM..."
    cd "$TPM_DIR" && git pull
else
    echo "Installing TPM..."
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "Done."
