if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
 source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

unsetopt correct_all
setopt histignorealldups sharehistory

# Config
export DISABLE_UPDATE_PROMPT="false"
export DISABLE_LS_COLORS="true"
export COMPLETION_WAITING_DOTS="true"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob=!.git --glob=!node_modules"
export FZF_DEFAULT_OPTS="--bind alt-up:preview-half-page-up,alt-down:preview-half-page-down"
export BAT_THEME="TwoDark"
export EDITOR=nvim
export ZVM_CURSOR_STYLE_ENABLED=false
export ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew";
export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";
export GOPATH="$HOME/.go"
export NIMPATH="$HOME/.nim"
export NIMBLEPATH="$HOME/.nimble"
export GOBIN="$GOPATH/bin"
export NIMBIN="$NIMPATH/bin"
export NIMBLE_BIN="$NIMBLEPATH/bin"

export PERSONAL="$HOME/dev/personal"
export DOTFILES="$HOME/.dotfiles"
export XDG_DATA_DIRS="$HOMEBREW_PREFIX/share:$XDG_DATA_DIRS"

# Path
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
export PATH="$GOBIN:$PATH"
export PATH="$NIMBIN:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Source
source $DOTFILES/zsh/config.zsh
source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.p10k.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-vi-mode/zsh-vi-mode.zsh

# Load seperated config files
for conf in "$DOTFILES/zsh/config/"*.zsh; do
  source "${conf}"
done
unset conf

if [[ -r "$HOME/.secret/work.zsh" ]]; then
    source $HOME/.secret/work.zsh
fi

bindkey -r '^a'
bindkey -r '^r'
bindkey -r '^b'

bindkey -s '^a' 'fzf-open-project\n'
bindkey -s '^b' 'change_wallpaper\n'

