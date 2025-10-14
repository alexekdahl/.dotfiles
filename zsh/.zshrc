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


# ------------------------------------------------------------------------------
# Core config (aliases, functions, environment, etc.)
# ------------------------------------------------------------------------------
for conf_file in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  zsource "${conf_file}"
done
unset conf_file

if [[ -r "$HOME/.secret/work.zsh" ]]; then
    zsource "$HOME/.secret/work.zsh"
fi

# ------------------------------------------------------------------------------
# Plugins
# ------------------------------------------------------------------------------
zsource "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
zsource "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
