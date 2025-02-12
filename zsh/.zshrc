if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

unsetopt correct_all
setopt histignorealldups sharehistory

# ------------------------------------------------------------------------------
# Core config (aliases, functions, environment, etc.)
# ------------------------------------------------------------------------------

for conf_file in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  source "${conf_file}"
done
unset conf_file

if [[ -r "$HOME/.secret/work.zsh" ]]; then
    source "$HOME/.secret/work.zsh"
fi

# ------------------------------------------------------------------------------
# Plugins & Theme
# ------------------------------------------------------------------------------
source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
source "$HOME/.p10k.zsh"
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.zsh/zsh-vi-mode/zsh-vi-mode.zsh"

