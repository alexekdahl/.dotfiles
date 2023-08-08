# -History-
alias h="history -10"
alias hg="history | grep"

# -Vim-
alias vim="nvim"
alias vi="nvim"
alias v="vim"

# -Misc-
alias brewski="brew doctor && brew update && brew upgrade && brew cleanup"
alias today='icalBuddy -f -sd -iep datetime,title -df %A  eventsToday'
alias week='icalBuddy -f -sd -iep datetime,title -df %A eventsToday+7'
alias tomorrow='icalBuddy -f -sd -iep datetime,title -df %A eventsToday+1'

alias editzsh='nvim ~/.dotfiles/zsh/'
alias editvim='nvim ~/.dotfiles/nvim/'
alias reload='source ~/.zshrc'
alias c='clear'

alias wttr='curl -s wttr.in/Lund'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias scs='open ~/Pictures/screenshots'
alias topcmd='history | awk '\''{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10'

# -Network-
alias mip='ipconfig getifaddr en0'
alias ports='lsof -i -n -P'
alias spdt='speedtest -s 31538'

# -Node-
alias check='npx depcheck'
alias yolo='rm -rf node_modules/ && npm install'
alias npd='npm run dev'
alias fix='npx prettier --print-width 120 --single-quote --trailing-comma es5 --write "**/*.{js,ts}"'

# -Dir-
alias ..='cd ..'
alias mv='mv -iv'
alias cp='cp -iv'
alias ls='exa --icons --colour=never -1 --sort=type'
alias lsa='ls -a'
alias dev='cd ~/dev && echo "$(tput setaf 1)Projects"$(tput sgr0) && ls'
alias war='cd ~/dev/misc && vim .'
alias copy='pbcopy < '
alias dotfiles='cd ~/.dotfiles'
alias tree='exa --tree --git-ignore --sort=type'
alias nvm='fnm'

