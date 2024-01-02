# Find a file and open it in Vim
function ff() {
  file=$(fzf --preview='bat --style=numbers --color=always {}' --bind ctrl-k:preview-half-page-up,ctrl-j:preview-half-page-down) && vim $(echo "$file")
}

# Find pattern inside a file and open it in Neovim at the line where the pattern is found and sets Neovim root to git root.
function fff() {
  local file
  local pattern=$1
  local result
  local git_root
  result=$(rg -i -n --no-messages "$pattern" | fzf --preview="echo {} | awk -F: '{start=\$2 - 10; if (start < 0) start=0; print \"bat --style=numbers --color=always --line-range=\" start \":\" \$2+40 \" \" \$1 \" --highlight-line=\" \$2}' | sh" --bind ctrl-k:preview-half-page-up,ctrl-j:preview-half-page-down)
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
  local work_root="$HOME/dev/axis/repo"
  local personal_root="$HOME/dev/personal"
  local dotfiles_root="$HOME/.dotfiles"
  local downloads_root="$HOME/Downloads"
  local config_root="$HOME/.config"

  local personal_root_color="\033[32m"
  local work_root_color="\033[33m"
  local dotfiles_root_color="\033[35m"
  local config_root_color="\033[36m"
  local reset_color="\033[0m"

  local fzf_height="50%"
  local dir

  # Include dotfiles_root and config_root separately to avoid listing their subdirectories
  dir=$( (find $work_root $personal_root -mindepth 1 -maxdepth 1 -type d; echo $dotfiles_root; echo $downloads_root; echo $config_root) \
      | awk -v work="$work_root" -v personal="$personal_root" -v dotfiles="$dotfiles_root" -v downloads="$downloads_root" -v config="$config_root" -v workColor="$work_root_color" -v personalColor="$personal_root_color" -v dotfilesColor="$dotfiles_root_color" -v downloadsColor="$dotfiles_root_color" -vreset="$reset_color" '
          { if ($0 == dotfiles)
              printf dotfilesColor "%s" reset "\n", $0
            else if ($0 == downloads)
              printf downloadsColor "%s" reset "\n", $0
            else if ($0 == config)
              printf dotfilesColor "%s" reset "\n", $0
            else if (index($0, work) > 0)
              printf workColor "%s" reset "\n", $0
            else if (index($0, personal) > 0)
              printf personalColor "%s" reset "\n", $0
          }' \
      | fzf --ansi --print0 -m -1 --border=rounded --height $fzf_height)

  [[ -n "$dir" ]] && cd "$dir"
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
    selected_wallpaper=$(find ~/Pictures/wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) | fzf --border=rounded --height 40%)

    if [[ -n $selected_wallpaper ]]; then
        feh --bg-fill "$selected_wallpaper"
    else
        echo "No wallpaper selected."
    fi
}
