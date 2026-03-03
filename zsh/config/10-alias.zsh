# -Tmux-
alias th="tmux new-session -A -s MISC '~/.dotfiles/scripts/startup.sh; exec $SHELL'"

# -Vim-
alias vim="nvim"
alias v="\vim"
alias vi="vim"

# -Misc-
alias brewski="brew doctor; brew update && brew upgrade && brew cleanup -s"
alias reload='source ~/.zshrc'
alias update='sudo apt update && sudo apt upgrade -y; sudo snap refresh; brewski; sudo apt auto-remove'
alias myip='ip -br a'

# -Python-
alias py='python3'

# -Hmm-
alias ..='cd ..'
alias ...='echo "from: $(pwd)" && cd ../.. && echo "to:   $(pwd)"'
alias mv='mv -iv'
alias cp='cp -iv'
alias mkdir='mkdir -p'
alias ls="ls --color=always"
alias lsa="ls -a -d .??*"
alias ll='ls -lhF --group-directories-first'
alias lla='ls -laF -d .??* --group-directories-first'
alias diff='nvim -d'
alias nvm='fnm'
alias tree='eza --tree --sort=type'
alias c='clear'
alias :q='exit'
alias copy='xclip -selection clipboard -i'

# -goto-
alias godoc='cd $HOMEBREW_PREFIX/Cellar/go/'

