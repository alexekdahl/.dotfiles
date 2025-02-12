HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";

export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew";
export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";
export GOPATH="$HOME/.local/go"
export NIMPATH="$HOME/.local/nim"
export NIMBLEPATH="$HOME/.local/nimble"
export GOBIN="$GOPATH/bin"
export NIMBIN="$NIMPATH/bin"
export NIMBLE_BIN="$NIMBLEPATH/bin"

export PERSONAL="$HOME/dev/personal"
export DOTFILES="$HOME/.dotfiles"
export XDG_DATA_DIRS="$HOMEBREW_PREFIX/share:$XDG_DATA_DIRS"
export XDG_CONFIG_HOME="$HOME/.config"

# Path
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
export PATH="$GOBIN:$PATH"
export PATH="$NIMBIN:$PATH"
export PATH="$HOME/.local/bin:$PATH"
