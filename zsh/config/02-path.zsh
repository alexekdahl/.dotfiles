HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";

export XDG_CONFIG_HOME="$HOME/.config"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew";
export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";
export GOPATH="$HOME/.go"
export NIMPATH="$HOME/.nim"
export ZIGPATH="$HOME/.zig"
export NIMBLEPATH="$HOME/.nimble"
export GOBIN="$GOPATH/bin"
export NIMBIN="$NIMPATH/bin"
export NIMBLEBIN="$NIMBLEPATH/bin"
export ZIGBIN="$ZIGPATH"
export CARGOBIN="$HOME/.cargo/bin"
export PERSONAL="$HOME/dev/personal"
export DOTFILES="$HOME/.dotfiles"
export XDG_DATA_DIRS="$HOMEBREW_PREFIX/share:$XDG_DATA_DIRS"

# Path
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
export PATH="$GOBIN:$PATH"
export PATH="$NIMBLEBIN:$PATH"
export PATH="$NIMBIN:$PATH"
export PATH="$CARGOBIN:$PATH"
export PATH="$ZIGBIN:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export PATH="$HOME/.local/share/fnm/aliases/default/bin:$PATH"
