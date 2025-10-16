# compile zsh file, and source them - first run is slower
function zsource() {
  local file=$1
  local zwc="${file}.zwc"
  if [[ -r "$file" ]]; then
    if [[ ! -r "$zwc" || "$file" -nt "$zwc" ]]; then
      zcompile "$file"
    fi
    source "$file"
  fi
}

zsource "$HOME/.dotfiles/zsh/config/01-env.zsh"
zsource "$HOME/.dotfiles/zsh/config/02-path.zsh"
zsource "$HOME/.dotfiles/zsh/config/09-settings.zsh"
zsource "$HOME/.dotfiles/zsh/config/20-keybinds.zsh"

zsource "$HOME/.zsh/zsh-defer/zsh-defer.plugin.zsh"
zsource "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
zsource "$HOME/.p10k.zsh"

zsh-defer zsource "$HOME/.dotfiles/zsh/config/10-alias.zsh"
zsh-defer zsource "$HOME/.dotfiles/zsh/config/11-functions.zsh"
zsh-defer zsource "$HOME/.dotfiles/zsh/config/12-docker.zsh"
zsh-defer zsource "$HOME/.dotfiles/zsh/config/13-git.zsh"
zsh-defer zsource "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
zsh-defer zsource "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

zsh-defer zsource "$HOME/.secret/work.zsh"
