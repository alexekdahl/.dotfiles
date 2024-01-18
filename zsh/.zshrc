if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
 source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
unsetopt correct_all
setopt histignorealldups sharehistory
export HISTFILE="$HOME/.zsh_history"

# Config
export DISABLE_UPDATE_PROMPT="false"
export DISABLE_LS_COLORS="true"
export COMPLETION_WAITING_DOTS="true"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob=!.git --glob=!node_modules"
export EDITOR=nvim

# Path
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
export MODULAR_HOME="$HOME/.modular"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}";
export GOPATH="$HOME/.go"

export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"


eval "$(fnm env)"
# Source
source ~/.dotfiles/zsh/config.zsh
source /home/linuxbrew/.linuxbrew/share/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load seperated config files
for conf in "$HOME/.dotfiles/zsh/config/"*.zsh; do
  source "${conf}"
done
unset conf

source ~/.secret/work.zsh

bindkey -r '^a'
bindkey -r '^r'
bindkey -s '^a' 'fzf-open-project\n'

bindkey -r '^b'
bindkey -s '^b' 'change_wallpaper\n'

