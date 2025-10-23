#!/usr/bin/env bash

set -e

# Clone dotfiles if not already present
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

if [[ ! -d "$DOTFILES" ]]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/alexekdahl/.dotfiles "$DOTFILES"
else
    echo "Dotfiles already exist at $DOTFILES"
fi

# Source and execute the main setup script
if [[ -f "$DOTFILES/setup/setup.sh" ]]; then
    echo "Running setup script..."
    bash "$DOTFILES/setup/setup.sh"
else
    echo "Error: setup.sh not found in $DOTFILES"
    exit 1
fi
