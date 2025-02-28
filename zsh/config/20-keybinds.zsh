# enable vi mode
bindkey -v

bindkey -r '^a'
bindkey -r '^b'
bindkey -s '^a' 'fzf-open-project\n'
bindkey -s '^b' 'change_wallpaper\n'

zle -N fzf-history
bindkey '^r' fzf-history
