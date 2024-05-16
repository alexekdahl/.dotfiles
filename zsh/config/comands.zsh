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

    file=$(fzf --preview='bat --style=numbers --color=always {}') && vim "$file"
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

function fzf-open-project() {
    source $HOME/.dotfiles/scripts/sessionizer.sh
}

# -Misc-

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

function change_wallpaper() {
    local selected_wallpaper
    selected_wallpaper=$(find ~/Pictures/wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) | fzf --border=rounded --height 50%)

    if [[ -n $selected_wallpaper ]]; then
        feh --bg-fill "$selected_wallpaper"
    else
        echo "No wallpaper selected."
    fi
}

function gtest(){
    local test_name="$1"
    local dir_path="$2"
    go test -run "$test_name" "${dir_path}..." -v --count=1
}
