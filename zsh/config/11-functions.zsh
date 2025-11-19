# Find a file and open it in Vim
function ff() {
    local choice
    local file
    
    # Check if in a bare repository (suppress errors for non-git folders)
    if git rev-parse --is-bare-repository 2>/dev/null | grep -q "true"; then
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
      man "$cmd" | col -bx | bat --style=plain --color=always --language=man
    else
      echo {} | sed "s/^[ \t]*[0-9]*\**[ \t]*//" | bat --style=plain --color=always --language=sh
    fi'
  
  # Atom One Dark inspired color scheme for fzf
  local fzf_colors="--color=fg:#D6D6D6,bg:#000000,hl:#85B884,fg+:#E1E1E1,bg+:#202020,hl+:#B3DBA9,pointer:#D7867D,info:#FFE591,spinner:#60B197,header:#ABBAB5,prompt:#AA749F,marker:#F6AD6C"  

  # Color for different command types using your palette
  local highlight_cmd='
    sed "s/\(sudo\)/\x1b[38;2;224;108;117m\1\x1b[0m/g;
         s/\(git\)/\x1b[38;2;152;195;121m\1\x1b[0m/g;
         s/\(docker\|kubectl\)/\x1b[38;2;97;175;239m\1\x1b[0m/g;
         s/\(vim\|nvim\|vi\)/\x1b[38;2;198;120;221m\1\x1b[0m/g;
         s/\(ssh\|scp\)/\x1b[38;2;229;192;123m\1\x1b[0m/g"'
  
  # Use minimal local options for safety
  setopt localoptions noglob
  
  if zmodload -F zsh/parameter p:{commands,history} 2>/dev/null && (( ${+commands[perl]} )); then
    selected=$(printf '%s\t%s\0' "${(kv)history[@]}" |
      perl -0 -ne 'if (!$seen{(/^\s*[0-9]+\**\t(.*)/s, $1)}++) { s/\n/\n\t/g; print; }' |
      fzf --read0 --ansi --query="$LBUFFER" $fzf_colors --height=40% \
          --preview "$preview_cmd" --preview-window=top:30% \
          --bind="ctrl-r:toggle-sort" \
          --header=$'\e[38;2;86;182;194mCTRL-R\e[0m: Toggle Sort | \e[38;2;152;195;121mEnter\e[0m: Execute | \e[38;2;229;192;123mESC\e[0m: Cancel' |
      eval "$highlight_cmd")
  else
    selected=$(fc -rl 1 | awk '{
      cmd=$0; 
      sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); 
      if (!seen[cmd]++) print $0 
    }' | eval "$highlight_cmd" |
      fzf --ansi --query="$LBUFFER" $fzf_colors --height=40% \
          --preview "$preview_cmd" --preview-window=top:30% \
          --bind="ctrl-r:toggle-sort" \
          --header=$'\e[38;2;86;182;194mCTRL-R\e[0m: Toggle Sort | \e[38;2;152;195;121mEnter\e[0m: Execute | \e[38;2;229;192;123mESC\e[0m: Cancel')
  fi
  
  ret=$?
  
  if [ -n "$selected" ]; then
    if [[ $(awk '{print $1; exit}' <<< "$selected") =~ ^[1-9][0-9]* ]]; then
      zle vi-fetch-history -n $MATCH
    else
      # Strip ANSI color codes when setting LBUFFER
      LBUFFER=$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g' | sed 's/^[ \t]*[0-9]*\**[ \t]*//')
    fi
  fi
  
  zle reset-prompt
  return $ret
}

function fzf-open-project() {
    source $DOTFILES/scripts/sessionizer.sh
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
