# -History-
alias h="history -10"
alias hg="history | grep"

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

# -Network-
alias mip='ipconfig getifaddr en0'
alias ports='lsof -i -n -P'

# -Node-
alias yolo='rm -rf node_modules/ && npm install'

# -Dir-
alias ..='cd ..'
alias mv='mv -iv'
alias cp='cp -iv'
alias ls='exa --icons --colour=never -1 --sort=type'
alias lsa='ls -a'
alias dev='cd ~/dev && echo "$(tput setaf 1)Projects"$(tput sgr0) && ls'
alias dotfiles='cd ~/.dotfiles'
alias tree='exa --tree --git-ignore --sort=type'
alias nvm='fnm'

