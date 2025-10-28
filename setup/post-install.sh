#!/usr/bin/env bash
set -e
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/setup/post.Brewfile"

if [[ -f "$BREWFILE" ]]; then
    echo "Installing Homebrew packages from Brewfile..."
    brew bundle install --file="$BREWFILE"
fi

mv $HOME/go $HOME/.go

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo apt update -y
sudo apt install brave-browser -y

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
