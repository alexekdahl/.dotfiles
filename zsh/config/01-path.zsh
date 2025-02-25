HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";

export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew";
export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";
export GOPATH="$HOME/.local/go"
export GOBIN="$GOPATH/bin"
export NIMBLEPATH="$HOME/.local/lang/nimble"
export NIMBLEBIN="$NIMBLEPATH/bin"
export CARGOBIN="$HOME/.cargo/bin"
export PERSONAL="$HOME/dev/personal"
export DOTFILES="$HOME/.dotfiles"
export XDG_DATA_DIRS="$HOMEBREW_PREFIX/share:$XDG_DATA_DIRS"
export XDG_CONFIG_HOME="$HOME/.config"

# Path
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
export PATH="$GOBIN:$PATH"
export PATH="$NIMBLEBIN:$PATH"
export PATH="$CARGOBIN:$PATH"
export PATH="$HOME/.local/bin:$PATH"
