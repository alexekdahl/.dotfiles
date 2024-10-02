#!/bin/bash

DOTFILES="$HOME/.dotfiles"


function install_fonts() {
    if [ ! -d "$HOME/.local/share/fonts" ]; then
        mkdir -p "$HOME/.local/share/fonts"
    fi

    unzip -o "$DOTFILES/fonts/fons.zip" -d "$HOME/.local/share/fonts"
    fc-cache -f -v
}

function symlink_alacritty() {
    if [ -f "$XDG_CONFIG_HOME/alacritty" ]; then
        rm -rf "$XDG_CONFIG_HOME/alacritty"
    fi

    ln -sf "$DOTFILES/alacritty/alacritty" "$XDG_CONFIG_HOME/alacritty"
}

function symlink_zsh() {
    if [ -f "$HOME/.zshrc" ]; then
        rm "$HOME/.zshrc"
    fi

    ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
}

function symlink_p10k() {
    if [ -f "$HOME/.p10k.zsh" ]; then
        rm "$HOME/.p10k.zsh"
    fi

    ln -sf "$DOTFILES/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
}

function symlink_nvim() {
    if [ -d "$XDG_CONFIG_HOME/nvim" ]; then
        rm -rf "$XDG_CONFIG_HOME/nvim"
    fi


    ln -sf "$DOTFILES/nvim" "$XDG_CONFIG_HOME/nvim"
}

function symlink_tmux() {
    if [ -f "$XDG_CONFIG_HOME/tmux" ]; then
        rm -rf "$XDG_CONFIG_HOME/tmux"
    fi

    ln -sf "$DOTFILES/tmux" "$XDG_CONFIG_HOME/tmux"
}

function symlink_vim() {
    if [ -f "$HOME/.vimrc" ]; then
        rm "$HOME/.vimrc"
    fi

    ln -sf "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"
}

function setup_git() {
    if [ -f "$HOME/.gitconfig" ]; then
        rm "$HOME/.gitconfig"
    fi

    cp "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

    if [ -f "$HOME/.githooks" ]; then
        rm -rf "$HOME/.githooks"
    fi

    mkdir -p "$HOME/.githooks"
    
    ln -sf "$DOTFILES/git/pre-commit" "$HOME/.githooks/"
    ln -sf "$DOTFILES/git/pre-push" "$HOME/.githooks/"


    mkdir -p "$HOME/local/bin"
    if [ -f "$HOME/local/bin/git-bare-clone" ]; then
        rm "$HOME/local/bin/git-bare-clone"
    fi

    ln -sf "$DOTFILES/git/git-bare-clone.sh" "$HOME/local/bin/git-bare-clone"
    chomod +x "$HOME/local/bin/git-bare-clone"

    if [ -f "$HOME/local/bin/git-rebase-own" ]; then
        rm "$HOME/local/bin/git-rebase-own"
    fi

    ln -sf "$DOTFILES/git/git-rebase-own" "$HOME/local/bin/git-rebase-own"
    chomod +x "$HOME/local/bin/git-rebase-own"
}

function download_tmux_plugins() {
    # Clone tpm
    if [ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ]; then
      git clone "https://github.com/tmux-plugins/tpm" "$XDG_CONFIG_HOME/tmux/plugins/tpm"
    fi
}

function download_zsh_plugins() {
    # Clone zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/zsh-autosuggestions" ]; then
      git clone "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/zsh-autosuggestions"
    else
      echo "zsh-autosuggestions already exists."
    fi

    # Clone zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/zsh-syntax-highlighting" ]; then
      git clone "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/zsh-syntax-highlighting"
    else
      echo "zsh-syntax-highlighting already exists."
    fi
}

function main() {
    mkdir -p "$XDG_CONFIG_HOME"

    install_fonts
    symlink_alacritty
    symlink_zsh
    symlink_p10k
    symlink_nvim
    symlink_vim
    symlink_tmux
    download_tmux_plugins
    download_zsh_plugins
    setup_git
}

main()
