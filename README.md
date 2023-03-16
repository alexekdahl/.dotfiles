[![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white&style=for-the-badge)](https://www.apple.com/macos)
[![Neovim](https://img.shields.io/badge/Neovim-57A143?logo=neovim&logoColor=white&style=for-the-badge)](https://neovim.io)
[![Oh My Zsh](https://img.shields.io/badge/Oh_My_Zsh-1A2C34?logo=gnu-bash&logoColor=white&style=for-the-badge)](https://ohmyz.sh)
[![iTerm2](https://img.shields.io/badge/iTerm2-000000?logo=iterm2&logoColor=white&style=for-the-badge)](https://iterm2.com)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white&style=for-the-badge)](https://www.docker.com)
[![Yabai](https://img.shields.io/badge/Yabai-2980b9?style=for-the-badge)](https://github.com/koekeishiya/yabai)
[![skhd](https://img.shields.io/badge/skhd-16a085?style=for-the-badge)](https://github.com/koekeishiya/skhd)
[![FZF](https://img.shields.io/badge/FZF-5D3FBB?style=for-the-badge)](https://github.com/junegunn/fzf)
[![QMK Firmware](https://img.shields.io/badge/QMK-Firmware-5391FE?logo=qmk&logoColor=white&style=for-the-badge)](https://qmk.fm)
[![Powerlevel10k](https://img.shields.io/badge/Powerlevel10k-1abc9c?style=for-the-badge)](https://github.com/romkatv/powerlevel10k)

# My Dotfiles
![Setup Screenshot](images/setup.png)
This repository contains my personal dotfiles for setting up a new development environment.

## Installation

To install these dotfiles on a new machine, follow these steps:

1. Install [Homebrew](https://brew.sh/) if you haven't already:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```
2. Install [Oh My Zsh](https://ohmyz.sh/) framework:
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

```
3. Install the dependencies listed in the `Brewfile`:
```bash
brew bundle
```
4. Install [vim-plug](https://github.com/junegunn/vim-plug)
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
5. Create symbolic links for each file that you want to include in your dotfiles repository.
```bash
ln -s ~/.dotfiles/yabai/yabairc ~/.config/yabai/yabairc
ln -s ~/.dotfiles/skhd/skhdrc ~/.config/skhd/skhdrc
ln -s ~/.dotfiles/p10k/p10k.zsh ~/.p10.zsh
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/.dotfiles/nvim/lua/ ~/.config/nvim/lua/
ln -s ~/.dotfiles/nvim/init.vim ~/.config/nvim/init.vim
```

Or run the script [symlinks.sh](https://github.com/AlexEkdahl/.dotfiles/blob/main/scripts/symlinks.sh)
```bash
./scripts/symlinks.sh
```

### Iterm

0. Unzip the fonts in `/fonts` and install.

1. Open iTerm2.
2. Go to "iTerm2" in the menu bar > "Preferences".
3. Click on the "General" tab.
4. Check the box that says "Load preferences from a custom folder or URL".
5. Click on the "Browse" button and navigate to the `iterm2` folder in this dotfiles repository.
7. Close and reopen iTerm2 to apply the new settings.


## Features
[![Neovim Startup Time](https://img.shields.io/badge/Neovim%20Startup%20Time-%3C80ms-brightgreen)](https://neovim.io/)

Here are some of the features that are included in this dotfiles repository:

- Customized `zsh` shell configuration with plugins like `zsh-autosuggestions` and `zsh-syntax-highlighting`
- Custom `git` configuration and aliases like `gamend` for git commit --amend with confirmation for protected branches and `grename` for renaming branches locally and remotely.
- Custom `fzf` configuration for fuzzy finding.
- Custom `docker` aliases for managing containers like `ds` for selecting a running container to stop and `dbash` for selecting a running container to enter shell.
- Custom `neovim` configuration and plugins including `onedark` theme, `lsp` and `treesitter` for language support, `telescope` for fuzzy finding, `spellbee` for spell checking, and more.
- Custom `yabai` and `skhd` configuration files for macOS window and shortcut management.
- Custom `iterm2` configuration files for terminal preferences.
- Custom `vscode` configuration files for keybindings and settings.
- Custom `p10k` configuration files for `powerlevel10k` theme.

- Additional files for keyboard firmware configuration and fonts.
