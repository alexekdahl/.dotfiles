if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
 source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Multi session node environment
eval "$(fnm env)"

# Config
export DISABLE_UPDATE_PROMPT="false"
export DISABLE_LS_COLORS="true"
export COMPLETION_WAITING_DOTS="true"
export HOMEBREW_NO_ANALYTICS=1
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob=!.git --glob=!node_modules"
export EDITOR=nvim
export HISTFILE="$HOME/.zsh_history"

# Path
export GOPATH="$HOME/.go"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.go/bin:$PATH"
export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"


# Source
source ~/.dotfiles/zsh/config.zsh
source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load separated config files
for conf in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  source "${conf}"
done
unset conf

bindkey -r '^a'
bindkey -s '^a' 'fzf-open-project\n'

nvm_autouse &>/dev/null
chpwd_functions=(${chpwd_functions[@]} "nvm_autouse")
