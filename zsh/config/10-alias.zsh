# -Tmux-
alias th="tmux new-session -A -s MISC"

# -Zellij-
alias zz="zellij kill-all-sessions -y; zellij delete-all-sessions -y"

# -Vim-
alias vim="nvim"
alias v="\vim"

# -Misc-
alias brewski="brew doctor; brew update && brew upgrade && brew cleanup -s"
alias reload='source ~/.zshrc'
alias update='sudo apt update && sudo apt upgrade -y; sudo snap refresh; brewski; sudo apt auto-remove'
alias c='clear'
alias :q='exit'
alias lock='i3lock -c 191900'
alias copy='xclip -selection clipboard -i'

alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias aliaz='alias | awk -F"=" '\''{printf "\033[1;34m%s\033[0m=\033[0;32m%s\033[0m\n", $1, $2}'\'' | fzf --border=rounded --height 50% --ansi'

# -Network-
alias ports='lsof -i -n -P'
alias spdt='speedtest --simple'
alias myip='ip -br a'

# -Go-
# alias test='go test ./... -count=1 --short --race | gocolorize'

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
alias ls='eza --icons --colour=never -1 --sort=type'
alias lsa='ls -a'
alias ll='eza --icons --header --long --grid --no-user --sort=type'
alias diff='nvim -d'
alias nvm='fnm'
alias tree='eza --tree --sort=type'
alias blue='bluetoothctl connect "30:91:BD:18:14:81"'

# -goto-
alias dev='cd ~/dev && echo "$(tput setaf 1)Dev"$(tput sgr0) && ls'
alias misc='cd ~/dev/misc && echo "$(tput setaf 1)Misc"$(tput sgr0) && ls'
alias dotfiles='cd $DOTFILES'

