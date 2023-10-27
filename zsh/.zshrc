# Multi session node environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# eval "$(fnm env)"

# Config
export DISABLE_UPDATE_PROMPT="false"
export DISABLE_LS_COLORS="true"
export COMPLETION_WAITING_DOTS="true"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob=!.git --glob=!node_modules"
export EDITOR=nvim
# Path
export GOPATH="$HOME/.go"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

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
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(up-line-or-history up-history forward-char expand-or-complete)

# Source
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.dotfiles/zsh/custom_promt.zsh

# Load seperated config files
for conf in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  source "${conf}"
done
unset conf

bindkey -r '^a'
bindkey -s '^a' 'fzf-open-project\n'

