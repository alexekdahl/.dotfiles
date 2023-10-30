# Multi session node environment
eval "$(fnm env)"

# Config
export DISABLE_UPDATE_PROMPT="false"
export DISABLE_LS_COLORS="true"
export COMPLETION_WAITING_DOTS="true"
export HOMEBREW_NO_ANALYTICS=1
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob=!.git --glob=!node_modules"
export EDITOR=nvim

# Path
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/.go"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.go/bin:$PATH"
export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"

export HISTFILE="$HOME/.zsh_history"

autoload -Uz compinit
compinit

# Customize completion behavior
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*'
zstyle ':completion:*:cd:*' tag-order 'local-directories named-directories'
zstyle ':completion:*:correct:*' insert-unambiguous true

# Autosuggestions Configuration
export ZSH_AUTOSUGGEST_USE_REGEX_MATCHING=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(up-line-or-history up-history forward-char expand-or-complete)

# Source
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load separated config files
for conf in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  source "${conf}"
done
unset conf

source $HOME/.secrets/secrets/work.zsh
source $HOME/.dotfiles/zsh/custom_promt.zsh

bindkey -r '^a'
bindkey -s '^a' 'fzf-open-project\n'

nvm_autouse &>/dev/null
chpwd_functions=(${chpwd_functions[@]} "nvm_autouse")
