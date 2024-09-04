# -History-
alias h="history -10"
alias hg="history | grep"

# -Tmux-
alias th="tmux new-session -A -s MISC"

# -Zellij-
alias zz="zellij kill-all-sessions -y; zellij delete-all-sessions -y"

# -Vim-
alias vim="nvim"
alias vi="/usr/bin/vim"

# -Misc-
alias brewski="brew doctor; brew update && brew upgrade && brew cleanup -s"
alias reload='source ~/.zshrc'
alias update='sudo apt update && sudo apt upgrade -y; sudo snap refresh; brewski'
alias c='clear'
alias :q='exit'
alias lock='i3lock -c 191900'

alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias aliaz='alias | awk -F"=" '\''{printf "\033[1;34m%s\033[0m=\033[0;32m%s\033[0m\n", $1, $2}'\'' | fzf --border=rounded --height 50% --ansi'

# -Network-
alias ports='lsof -i -n -P'
alias spdt='speedtest --simple'

# -Go-
alias test='go test ./... -count=1 --short | gocolorize'

# -Python-
alias py='python3'

# -Node-
alias yolo='rm -rf node_modules/ && npm install'

# -Hmm-
alias ..='cd ..'
alias mv='mv -iv'
alias cp='cp -iv'
alias mkdir='mkdir -p'
alias du='du --max-depth=1 --si'
alias df='df --all --si --print-type'
alias ls='exa --icons --colour=never -1 --sort=type'
alias lsa='ls -a'
alias ll='exa --icons -1 --sort=type -alF'
alias diff='nvim -d'
alias nvm='fnm'
alias tree='exa --tree --sort=type'

# -goto-
alias dev='cd ~/dev && echo "$(tput setaf 1)Dev"$(tput sgr0) && ls'
alias misc='cd ~/dev/misc && echo "$(tput setaf 1)Misc"$(tput sgr0) && ls'
alias dotfiles='cd $DOTFILES'

