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

# Theme
export ZSH_THEME="robbyrussell"

# Path
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/.go"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.go/bin:$PATH"
export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"

# Plugins
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

# Source
# [[ ! -f ~/.p10k.zsh ]] ||

source $ZSH/oh-my-zsh.sh
source ~/.p10k.zsh
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

[ -f $HOME/.secrets/secrets/private.zsh ] && source $HOME/.secrets/secrets/private.zsh
[ -f $HOME/.secrets/secrets/work.zsh ] && source $HOME/.secrets/secrets/work.zsh

# Load seperated config files
for conf in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  source "${conf}"
done
unset conf


nvm_autouse &>/dev/null
chpwd_functions=(${chpwd_functions[@]} "nvm_autouse")
