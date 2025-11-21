#!/usr/bin/env bash
set -e

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/setup/post.Brewfile"

# Load Homebrew environment if not already loaded
if ! command -v brew &> /dev/null; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" || true
fi

# Install Homebrew packages if Brewfile exists
if [[ -f "$BREWFILE" ]]; then
    echo "[INFO] Installing Homebrew packages from Brewfile..."
    brew bundle install --file="$BREWFILE" || echo "[WARN] Homebrew packages installation had issues"
else
    echo "[WARN] Brewfile not found at $BREWFILE"
fi

# Install Rust (if not already installed)
if ! command -v rustup &> /dev/null; then
    echo "[INFO] Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Update Rust
rustup update || echo "[WARN] Rustup update failed"
rustup component add rust-analyzer || echo "[WARN] Could not add rust-analyzer"
cargo install just-lsp || echo "[WARN] Could not install just-lsp"

# Install Nim tools if nimble exists
if command -v nimble &> /dev/null; then
    echo "[INFO] Installing Nim language server..."
    nimble install nimlangserver -y || echo "[WARN] Could not install nimlangserver"
else
    echo "[WARN] nimble not found, skipping nimlangserver"
fi

echo "[SUCCESS] Post-install setup complete!"
