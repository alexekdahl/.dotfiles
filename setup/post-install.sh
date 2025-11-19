#!/usr/bin/env bash
set -e
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/setup/post.Brewfile"

if [[ -f "$BREWFILE" ]]; then
    echo "Installing Homebrew packages from Brewfile..."
    brew bundle install --file="$BREWFILE"
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
rustup component add rust-analyzer
cargo install just-lsp
nimble install nimlangserver
