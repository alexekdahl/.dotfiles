#!/usr/bin/env bash

set -e

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/setup/Brewfile"
ZSH_DIR="$HOME/.zsh"
FONTS_DIR="$HOME/.local/share/fonts"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
TMUX_CONFIG_DIR="$HOME/.config/tmux"

mkdir -p "$ZSH_DIR"
mkdir -p "$FONTS_DIR"
mkdir -p "$ALACRITTY_CONFIG_DIR"
mkdir -p "$TMUX_CONFIG_DIR"
mkdir -p "$HOME/.local/bin"

echo "Installing zsh plugins..."
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

ln -s "$DOTFILES/git/git-bare-clone" "$HOME/.local/bin/"
ln -s "$DOTFILES/git/git-rebase-own" "$HOME/.local/bin/"


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
TPM_DIR="$HOME/.local/share/tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    echo "Updating TPM..."
    cd "$TPM_DIR" && git pull
else
    echo "Installing TPM..."
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Symlink alacritty config directory
echo "Setting up alacritty configuration..."
ln -s "$DOTFILES/alcaritty" "$ALACRITTY_CONFIG_DIR"

# Symlink Neovim config directory
echo "Setting up Neovim configuration..."
ln -s "$DOTFILES/nvim" "$NVIM_CONFIG_DIR"

echo "Setting up vim configuration..."
ln -s "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"

# Load Homebrew into PATH if it exists
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "$HOME/.linuxbrew/bin/brew" ]]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
fi

# Install Homebrew packages
if [[ -f "$BREWFILE" ]]; then
    echo "Installing Homebrew packages from Brewfile..."
    brew bundle install --file="$BREWFILE"
fi

# Install fonts
echo "Installing fonts..."
if [[ -f "$DOTFILES/fonts/fonts.zip" ]]; then
    echo "Extracting fonts from fonts.zip..."
    unzip -o "$DOTFILES/fonts/fonts.zip" -d "$FONTS_DIR"
    
    # Rebuild font cache
    if command -v fc-cache &> /dev/null; then
        fc-cache -fv "$FONTS_DIR"
        echo "Font cache rebuilt"
    fi
else
    echo "fonts.zip not found at $DOTFILES/fonts/fonts.zip"
fi

$TPM_DIR/bin/install_plugins
nvim --headless "+Lazy! install" +qa

echo "Done! Run 'exec zsh' to start using your shell configuration."
