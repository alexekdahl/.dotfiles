if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
 source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# ENV

export PATH="/Users/alex/Library/Caches/fnm_multishells/46837_1657716775291/bin":$PATH
export FNM_MULTISHELL_PATH="/Users/alex/Library/Caches/fnm_multishells/46837_1657716775291"
export FNM_VERSION_FILE_STRATEGY="local"
export FNM_DIR="/Users/alex/Library/Application Support/fnm"
export FNM_LOGLEVEL="info"
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
export FNM_ARCH="arm64"

# Config
export DISABLE_UPDATE_PROMPT="false"
export DISABLE_LS_COLORS="true"
export COMPLETION_WAITING_DOTS="true"
export HOMEBREW_NO_ANALYTICS=1
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob=!.git --glob=!node_modules"
export NODE_ENV=local

# Theme
export ZSH_THEME="robbyrussell"

export NVM_DIR="$HOME/.nvm"
export PATH="/opt/homebrew/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export BUN_INSTALL="/Users/alex/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"
export GOPATH="$HOME/.go"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$PATH:./node_modules/.bin"
export APIKEYFILE="$HOME/dev/yale/august-runtime-creds/apicreds.json"

# Plugins
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

# Source

[ -s "/Users/alex/.bun/_bun" ] && source "/Users/alex/.bun/_bun"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/oh-my-zsh.sh
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# Load seperated config files
for conf in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  source "${conf}"
done
unset conf

nvm_autouse &>/dev/null
chpwd_functions=(${chpwd_functions[@]} "nvm_autouse")

