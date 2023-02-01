#  -----------------------------------------------------------------
#  -------db---------88-----------88---------db---------ad88888ba---
#  ------d88b--------88-----------88--------d88b-------d8"-----"8b--
#  -----d8'`8b-------88-----------88-------d8'`8b------Y8,----------
#  ----d8'--`8b------88-----------88------d8'--`8b-----`Y8aaaaa,----
#  ---d8YaaaaY8b-----88-----------88-----d8YaaaaY8b------`"""""8b,--
#  --d8""""""""8b----88-----------88----d8""""""""8b-----------`8b--
#  -d8'--------`8b---88-----------88---d8'--------`8b--Y8a-----a8P--
#  d8'----------`8b--88888888888--88--d8'----------`8b--"Y88888P"---
#  -----------------------------------------------------------------
#  -----------------------------------------------------------------


# -History-
alias h="history -10"
alias hg="history | grep"

# -Vim-
alias vim="nvim"
alias vi="nvim"
alias v="vim"
alias v.="vim ."

# -Git-
alias gco='git checkout'
alias gst='git status -s -b'
alias gstime='git status -s | while read mode file; do echo $mode $(stat -f "%Sm" $file) $file; done|sort'
alias ggp='git push origin $(current_branch)'
alias ggl='git pull origin $(current_branch)'
alias gsl="git stash list --pretty=format:'%Cblue%gd%Cred: %C(yellow)%s"
alias greset='git reset --hard HEAD'
alias uncommit='git reset --soft HEAD~'
alias gamend='git commit --amend --no-edit'
alias gamendm='git commit --amend -m'
alias gcm='git commit -m'
alias gwip='git add . && git commit -m "wip"'
# fzf
alias gcob='git branch | cut -c 3- | fzf --print0 -1 --border=rounded --height 10% | xargs git checkout'
alias gdb='git branch | cut -c 3- | fzf --print0 -m -1 --border=rounded --height 10% | xargs  -0 -t -o git branch -D'
alias gun='git --no-pager diff --name-only --cached | fzf --print0 -m -1 --border=rounded --height 10% | xargs -0 -t -o git reset'
alias gad='git ls-files -m -o --exclude-standard | fzf --print0 -m -1 --border=rounded --height 10% | xargs -0 -t -o git add'
alias remotebranch="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)    %(align:25,left)%(color:yellow)%(authorname)%(end) %(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"

# -Misc-
alias brewski="brew doctor && brew update && brew upgrade && brew cleanup"
alias today='icalBuddy -f -sd -iep datetime,title -df %A  eventsToday'
alias week='icalBuddy -f -sd -iep datetime,title -df %A eventsToday+7'
alias tomorrow='icalBuddy -f -sd -iep datetime,title -df %A eventsToday+1'
alias editzsh='nvim ~/.dotfiles/zsh/'
alias editvim='nvim ~/.dotfiles/nvim/'
alias reload='source ~/.zshrc'
alias wttr='curl -s wttr.in/Lund'
alias c='clear'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias scs='open ~/Pictures/screenshots'
alias pipe="grep --line-buffered -E 'info' | sed 's/^[^{]*//g'| jq ."
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
alias yale='cd ~/dev/yale && echo "$(tput setaf 1)Folders"$(tput sgr0) && ls'
alias repo='cd ~/dev/yale/repo && echo "$(tput setaf 1)Phoenix Repo"$(tput sgr0) && ls'
alias war='cd ~/dev/misc && vim .'
alias copy='pbcopy < '
alias dotfiles='cd ~/.dotfiles'
alias tree='exa --tree --git-ignore'
alias nvm='fnm'

# -Docker-
alias dils='docker image ls'
alias dps='docker ps'
alias dprune='docker volume prune --force'
alias dstop='docker kill $(docker ps -q)'
alias dkill='docker rmi $(docker images -a -q)'

# Association
alias -s md=code
alias -s json=code
alias -s txt=code

# Linux server monitor
alias freemem='free -t | awk "FNR == 2 {printf("Current Memory Utilization is : %.2f%"), $3/$2*100}"'
