
# Show cached promt on startup
 if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
 fi

# bun completions
[ -s "/Users/alex/.bun/_bun" ] && source "/Users/alex/.bun/_bun"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ENV

# Config
export DISABLE_UPDATE_PROMPT="false"
export DISABLE_LS_COLORS="true"
export COMPLETION_WAITING_DOTS="true"
export HOMEBREW_NO_ANALYTICS=1
export NVM_LAZY_LOAD=true
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob=!.git --glob=!node_modules"
export NODE_ENV=local

# Theme
export ZSH_THEME="robbyrussell"

export NVM_DIR="$HOME/.nvm"
export PATH="/opt/homebrew/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export PATH="$BUN_INSTALL/bin:$PATH"
export BUN_INSTALL="/Users/alex/.bun"
export APIKEYFILE="$HOME/dev/august-runtime-creds/apicreds.json"

# Plugins
plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-nvm)

# Source
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# Load seperated config files
for conf in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  source "${conf}"
done
unset conf

nvm_autouse &>/dev/null
chpwd_functions=(${chpwd_functions[@]} "nvm_autouse")

