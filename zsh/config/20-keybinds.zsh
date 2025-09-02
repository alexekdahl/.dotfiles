# enable vi mode
bindkey -v

bindkey -r '^a'
bindkey -s '^a' 'fzf-open-project\n'

zle -N fzf-history
bindkey '^r' fzf-history
