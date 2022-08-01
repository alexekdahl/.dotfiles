#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo timedatectl set-timezone Europe/Stockholm -y
sudo apt-get install zsh -y
chsh -s /usr/bin/zsh
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt-get update
sudo apt-get install neovim -y
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
sudo apt-get install clang -y
sudo apt-get install bat -y
sudo apt-get install exa -y
sudo apt-get install fzf -y
sudo apt-get install ripgrep -y

mkdir ~/.config
mkdir ~/.config/nvim/
if [[ -f "~/.zshrc" ]]; then
  rm "~/.zshrc"
fi
ln -s ~/.dotfiles/p10k/p10k-ubuntu.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/zsh/.zshrc-ubuntu ~/.zshrc
ln -s ~/.dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -s ~/.dotfiles/nvim/lua ~/.config/nvim/lua
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
source ~/.zshrc

sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo apt-get install lua5.2 -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

if [[ -f "~/.zshrc" ]]; then
  rm "~/.zshrc"
fi
ln -s ~/.dotfiles/zsh/.zshrc-ubuntu ~/.zshrc
source ~/.zshrc
