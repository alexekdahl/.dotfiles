# -History-
alias h="history -10"
alias hg="history | grep"

# -Tmux-
alias th="tmux new-session -A -s HOME"
alias tf="tmux new-session -A -s WORK"
# -Zellij-
alias zz="zellij kill-all-sessions -y; zellij delete-all-sessions -y"
alias zh="zellij --layout default"
# -Vim-
alias vim="nvim"
alias vi="nvim"
alias v="vim"
alias code="codium"

# -Misc-
alias brewski="brew doctor; brew update && brew upgrade && brew cleanup -s"

alias editzsh='nvim ~/.dotfiles/zsh/'
alias editvim='nvim ~/.dotfiles/nvim/'
alias econf='nvim ~/.config/'

alias reload='source ~/.zshrc'
alias c='clear'

alias wttr='curl -s wttr.in/Lund'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias topcmd='history | awk '\''{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n20'
alias aliaz='alias | awk -F"=" '\''{printf "\033[1;34m%s\033[0m=\033[0;32m%s\033[0m\n", $1, $2}'\'' | fzf --border=rounded --height 50% --ansi'

# -Network-
alias mip='ipconfig getifaddr en0'
alias ports='lsof -i -n -P'
alias spdt='speedtest --simple'

# -Node-
alias yolo='rm -rf node_modules/ && npm install'

# -Dir-
alias ..='cd ..'
alias mv='mv -iv'
alias cp='cp -iv'
alias ls='exa --icons --colour=never -1 --sort=type'
alias lsa='ls -a'
alias ll='ls -l'
alias dev='cd ~/dev && echo "$(tput setaf 1)Dev"$(tput sgr0) && ls'
alias repo='cd ~/dev/axis/repo && echo "$(tput setaf 1)Repo"$(tput sgr0) && ls'
alias dotfiles='cd ~/.dotfiles'
alias tree='exa --tree  --sort=type'
alias nvm='fnm'

