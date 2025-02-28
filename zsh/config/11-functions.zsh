# Find a file and open it in Vim
function ff() {
    local choice
    local file

    # Check if in a bare repository
    if [ "$(git rev-parse --is-bare-repository)" = "true" ]; then
        choice=$(find . -maxdepth 1 -type d | grep -v './.bare' | sed 's|^\./||' | fzf)
        if [ -z "$choice" ]; then
            return 0
        fi

        cd "$choice"
    fi

    file=$(fzf --preview='bat --style=numbers --color=always {}')
    [ -n "$file" ] && nvim "$file"
}

# Find pattern inside a file and open it in Neovim at the line where the pattern is found and sets Neovim root to git root.
function fff() {
  local file
  local pattern=$1
  local result
  local git_root
  result=$(rg -i -n --no-messages "$pattern" | fzf --preview="echo {} | awk -F: '{start=\$2 - 10; if (start < 0) start=0; print \"bat --style=numbers --color=always --line-range=\" start \":\" \$2+40 \" \" \$1 \" --highlight-line=\" \$2}' | sh")
  file=$(echo "$result" | awk -F: '{print $1}')
  line=$(echo "$result" | awk -F: '{print $2}')

  if [ -n "$file" ]; then
    git_root=$(git -C $(dirname "$file") rev-parse --show-toplevel 2>/dev/null)
  fi

  [ -n "$file" ] && [ -n "$line" ] && {
    if [ -n "$git_root" ]; then
      # Change local directory to Git root
      nvim +"lcd $git_root" +$line "$file"
    else
      nvim +$line "$file"
    fi
  }
}

function fzf-history() {
  local selected ret
  local preview_cmd='
    cmd=$(echo {} | awk "{print \$1}")
    if man "$cmd" &>/dev/null; then
      man "$cmd" | col -bx
    else
      echo {} | bat --style=plain --color=always --language=sh
    fi'

  # Use minimal local options for safety
  setopt localoptions noglob
  
  if zmodload -F zsh/parameter p:{commands,history} 2>/dev/null && (( ${+commands[perl]} )); then
    selected=$(printf '%s\t%s\0' "${(kv)history[@]}" |
      perl -0 -ne 'if (!$seen{(/^\s*[0-9]+\**\t(.*)/s, $1)}++) { s/\n/\n\t/g; print; }' |
      fzf --read0 --query="$LBUFFER" --height=10% --preview "$preview_cmd" --preview-window=top:10% --bind="ctrl-r:toggle-sort")
  else
    selected=$(fc -rl 1 | awk '{
      cmd=$0; 
      sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); 
      if (!seen[cmd]++) print $0 
    }' | fzf --query="$LBUFFER" --height=10%  --preview "$preview_cmd" --preview-window=top:10% --bind="ctrl-r:toggle-sort")
  fi
  
  ret=$?
  
  if [ -n "$selected" ]; then
    if [[ $(awk '{print $1; exit}' <<< "$selected") =~ ^[1-9][0-9]* ]]; then
      zle vi-fetch-history -n $MATCH
    else
      LBUFFER="$selected"
    fi
  fi
  
  zle reset-prompt
  return $ret
}

function fzf-open-project() {
    source $DOTFILES/scripts/sessionizer.sh
}

# -Misc-
function wttr() {
    curl -s wttr.in/$1
}

# Measure the start-up time for the shell
function timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 30); do time $shell -i -c exit; done
}

# fkill - kill processes - list only the ones you can kill.
function fkill() {
  local pid
  if [ "$UID" != "0" ]; then
      pid=$(ps -f -u $UID | sed 1d | fzf --print0 -m -1 --border=rounded | awk '{print $2}')
  else
      pid=$(ps -ef | sed 1d | fzf --print0 -m -1 --border=rounded | awk '{print $2}')
  fi
  if [ "x$pid" != "x" ]
  then
      echo $pid | xargs kill -${1:-9}
  fi
}

function sshprofile() {
   sshpass -p pass scp $DOTFILES/scripts/cam_profile root@$1:/root/.profile
}

function change_wallpaper() {
    local selected_wallpaper
    selected_wallpaper=$(find ~/Pictures/wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) | fzf --border=rounded --height 50%)

    if [[ -n $selected_wallpaper ]]; then
        feh --bg-fill "$selected_wallpaper"
    else
        echo "No wallpaper selected."
    fi
}
