#!/usr/bin/env bash

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/setup/Brewfile"
ZSH_DIR="$HOME/.zsh"
FONTS_DIR="$HOME/.local/share/fonts"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
TMUX_CONFIG_DIR="$HOME/.config/tmux"
LOCAL_BIN="$HOME/.local/bin"
TPM_DIR="$HOME/.local/share/tmux/plugins/tpm"

log_info() {
    echo "[INFO] $*"
}

log_success() {
    echo "[SUCCESS] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_info "Created directory: $dir"
    fi
}

clone_or_update_repo() {
    local repo_url="$1"
    local target_dir="$2"
    local repo_name
    repo_name=$(basename "$target_dir")

    if [[ -d "$target_dir" ]]; then
        log_info "Updating $repo_name..."
        (cd "$target_dir" && git pull)
    else
        log_info "Installing $repo_name..."
        git clone --depth=1 "$repo_url" "$target_dir"
    fi
}

backup_and_symlink() {
    local source="$1"
    local target="$2"
    
    # Remove existing symlink
    if [[ -L "$target" ]]; then
        rm "$target"
    fi
    
    # Backup existing file/directory
    if [[ -e "$target" ]]; then
        local backup="${target}.backup"
        log_info "Backing up existing $(basename "$target") to $backup"
        mv "$target" "$backup"
    fi
    
    # Create symlink
    ln -s "$source" "$target"
    log_success "Created symlink: $target -> $source"
}

create_directories() {
    log_info "Creating necessary directories..."
    ensure_dir "$ZSH_DIR"
    ensure_dir "$FONTS_DIR"
    ensure_dir "$ALACRITTY_CONFIG_DIR"
    ensure_dir "$TMUX_CONFIG_DIR"
    ensure_dir "$LOCAL_BIN"
}

install_zsh_plugins() {
    log_info "Installing zsh plugins..."
    
    clone_or_update_repo \
        "https://github.com/romkatv/zsh-defer.git" \
        "$ZSH_DIR/zsh-defer"
    
    clone_or_update_repo \
        "https://github.com/zsh-users/zsh-autosuggestions.git" \
        "$ZSH_DIR/zsh-autosuggestions"
    
    clone_or_update_repo \
        "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
        "$ZSH_DIR/zsh-syntax-highlighting"
}

setup_shell_configs() {
    log_info "Setting up shell configurations..."
    
    backup_and_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
    backup_and_symlink "$DOTFILES/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
}

setup_git_tools() {
    log_info "Setting up git tools..."
    
    local tools=("git-bare-clone" "git-rebase-own")
    for tool in "${tools[@]}"; do
        local source="$DOTFILES/git/$tool"
        local target="$LOCAL_BIN/$tool"
        
        if [[ -f "$source" ]]; then
            backup_and_symlink "$source" "$target"
        else
            log_error "Git tool not found: $source"
        fi
    done
}

setup_tmux_config() {
    log_info "Setting up tmux configuration..."
    
    backup_and_symlink "$DOTFILES/tmux/tmux.conf" "$TMUX_CONFIG_DIR/tmux.conf"
    backup_and_symlink "$DOTFILES/tmux/modules" "$TMUX_CONFIG_DIR/modules"
}

install_tpm() {
    log_info "Installing TPM (Tmux Plugin Manager)..."
    
    clone_or_update_repo \
        "https://github.com/tmux-plugins/tpm" \
        "$TPM_DIR"
}

install_homebrew() {
    if command -v brew &> /dev/null; then
        log_info "Homebrew already installed"
        return
    fi
    
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

load_homebrew() {
    local brew_paths=(
        "/home/linuxbrew/.linuxbrew/bin/brew"
        "/opt/homebrew/bin/brew"
        "$HOME/.linuxbrew/bin/brew"
    )
    
    for brew_path in "${brew_paths[@]}"; do
        if [[ -f "$brew_path" ]]; then
            eval "$("$brew_path" shellenv)"
            log_info "Loaded Homebrew from $brew_path"
            return
        fi
    done
}

install_brew_packages() {
    if [[ ! -f "$BREWFILE" ]]; then
        log_error "Brewfile not found at $BREWFILE"
        return 1
    fi
    
    log_info "Installing Homebrew packages from Brewfile..."
    brew bundle install --file="$BREWFILE"
}

setup_alacritty() {
    log_info "Setting up Alacritty configuration..."
    
    # Remove existing symlink if present
    if [[ -L "$ALACRITTY_CONFIG_DIR" ]]; then
        rm "$ALACRITTY_CONFIG_DIR"
    fi
    
    if [[ -d "$DOTFILES/alacritty" ]]; then
        backup_and_symlink "$DOTFILES/alacritty" "$ALACRITTY_CONFIG_DIR"
    else
        log_error "Alacritty config directory not found at $DOTFILES/alacritty"
    fi
}

setup_neovim() {
    log_info "Setting up Neovim configuration..."
    
    # Remove existing symlink if present
    if [[ -L "$NVIM_CONFIG_DIR" ]]; then
        rm "$NVIM_CONFIG_DIR"
    fi
    
    if [[ -d "$DOTFILES/nvim" ]]; then
        backup_and_symlink "$DOTFILES/nvim" "$NVIM_CONFIG_DIR"
    else
        log_error "Neovim config directory not found at $DOTFILES/nvim"
    fi
}

setup_vim() {
    log_info "Setting up vim configuration..."
    
    if [[ -f "$DOTFILES/vim/.vimrc" ]]; then
        backup_and_symlink "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"
    else
        log_error "Vimrc not found at $DOTFILES/vim/.vimrc"
    fi
}

install_fonts() {
    log_info "Installing fonts..."
    
    local fonts_zip="$DOTFILES/fonts/fonts.zip"
    
    if [[ ! -f "$fonts_zip" ]]; then
        log_error "fonts.zip not found at $fonts_zip"
        return 1
    fi
    
    log_info "Extracting fonts from fonts.zip..."
    unzip -o "$fonts_zip" -d "$FONTS_DIR"
    
    # Rebuild font cache
    if command -v fc-cache &> /dev/null; then
        fc-cache -fv "$FONTS_DIR"
        log_success "Font cache rebuilt"
    else
        log_info "fc-cache not found, skipping font cache rebuild"
    fi
}

install_tmux_plugins() {
    log_info "Installing tmux plugins..."
    
    if [[ -f "$TPM_DIR/bin/install_plugins" ]]; then
        "$TPM_DIR/bin/install_plugins"
    else
        log_error "TPM install_plugins script not found"
    fi
}

install_neovim_plugins() {
    log_info "Installing Neovim plugins..."
    
    if command -v nvim &> /dev/null; then
        nvim --headless "+Lazy! install" +qa
    else
        log_error "Neovim not found, skipping plugin installation"
    fi
}

main() {
    log_info "Starting dotfiles setup..."
    create_directories

    setup_shell_configs
    setup_git_tools
    setup_tmux_config
    setup_alacritty
    setup_neovim
    setup_vim

    install_homebrew
    load_homebrew

    install_brew_packages
    install_zsh_plugins
    install_tpm
    install_tmux_plugins
    install_neovim_plugins
    install_fonts

    log_success "Setup complete! Run 'source .zshrc' to start using your shell configuration."
}

# Run main function
main "$@"
