# Find a file and open it in Vim
function ff() {
  local file
  file=$(fzf --preview='bat --style=numbers --color=always {}' --bind ctrl-k:preview-half-page-up,ctrl-j:preview-half-page-down) && vim $(echo "$file")
}

# Find pattern inside a file and open it in Vim at the line where the pattern is found
function fff() {
  local file
  local pattern=$1
  local result
  result=$(rg -i -n --no-messages "$pattern" | fzf --preview="echo {} | awk -F: '{print \"bat --style=numbers --color=always \" \$1 \" --highlight-line=\" \$2}' | sh" --bind ctrl-k:preview-half-page-up,ctrl-j:preview-half-page-down)
  file=$(echo "$result" | awk -F: '{print $1}')
  line=$(echo "$result" | awk -F: '{print $2}')
  [ -n "$file" ] && [ -n "$line" ] && vim +$line $(echo "$file")
}

# -Misc-

# Measure the start-up time for the shell
function timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 30); do /usr/bin/time $shell -i -c exit; done
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

# Run an npm script
function nps() {
  local script
  script=$(cat package.json | jq -r '.scripts | keys[] ' | sort | fzf --print0 -m -1 --border=rounded --height 10%) && npm run $(echo "$script")
}

function rebuild() {
    local repo_name=$(basename "$(git rev-parse --show-toplevel)")
    if yolo && npm run build; then
        pong "$repo_name" "Yolo'd and rebuilt"
    else
        pong "$repo_name" "Failed"
    fi
}

# Execute a series of commands to start the day
function goodmorning() {
  today &&
  simp &&
  colima start &&
  dstart;
}

# Execute a series of commands to end the day
function goodbye() {
  tomorrow &&
  dstop &&
  colima stop;
}

# nvm autouse
function nvm_autouse() {
  if [[ -f ".nvmrc" ]]; then
    fnm use --silent-if-unchanged --log-level quiet
  fi
}
