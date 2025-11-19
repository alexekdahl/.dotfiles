# -Tmux-
alias th="tmux new-session -A -s MISC"

# -Vim-
alias vim="nvim"
alias v="\vim"
alias vi="vim"

# -Misc-
alias brewski="brew doctor; brew update && brew upgrade && brew cleanup -s"
alias reload='source ~/.zshrc'
alias update='sudo apt update && sudo apt upgrade -y; sudo snap refresh; brewski; sudo apt auto-remove'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"

# -Network-
alias ports='lsof -i -n -P'
alias listen='lsof -i -n -P | grep LISTEN'
alias portsproc='lsof -i -n -P | awk '\''NR==1 || !seen[$1]++'\'''

alias spdt='speedtest --simple'
alias myip='ip -br a'

# -Python-
alias py='python3'

# -Node-
alias yolo='rm -rf node_modules/ && npm install'

# -Hmm-
alias ..='cd ..'
alias ...='echo "from: $(pwd)" && cd ../.. && echo "to:   $(pwd)"'
alias mv='mv -iv'
alias cp='cp -iv'
alias mkdir='mkdir -p'
alias du='du --max-depth=1 --si'
alias df='df --all --si --print-type'
alias lsa="ls -a -d .??*"
alias ll='ls -lF --group-directories-first'
alias lla='ls -laF -d .??* --group-directories-first'
alias diff='nvim -d'
alias nvm='fnm'
alias tree='eza --tree --sort=type'
alias c='clear'
alias :q='exit'
alias copy='xclip -selection clipboard -i'

# -goto-
alias dev='cd ~/dev && echo "$(tput setaf 1)Dev"$(tput sgr0) && ls'
alias misc='cd ~/dev/misc && echo "$(tput setaf 1)Misc"$(tput sgr0) && ls'
alias dotfiles='cd $DOTFILES'
alias godoc='cd $HOMEBREW_PREFIX/Cellar/go/'

