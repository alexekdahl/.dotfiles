bindkey -r '^a'
bindkey -r '^b'
bindkey -s '^a' 'fzf-open-project\n'
bindkey -s '^b' 'change_wallpaper\n'

fzf-history-widget() {
  local key selected
  # --expect returns the pressed key on the first line.
  read -r key selected <<< "$(fc -rl 1 | fzf --query="$LBUFFER" --height 30% --expect=ctrl-c,esc)"
  # If the user pressed ctrl-c or esc, do nothing.
  if [[ $key == ctrl-c || $key == esc ]]; then
    zle reset-prompt
    return
  fi
  LBUFFER="$selected"
  zle reset-prompt
}

zle -N fzf-history-widget
bindkey '^r' fzf-history-widget
