# Find a file and open it in Vim
function ff() {
  local file
  file=$(fzf --preview='bat --style=numbers --color=always {}' --bind ctrl-j:preview-page-up,ctrl-k:preview-page-down) && vim $(echo "$file")
}

# Find pattern inside a file and open it in Vim
function fff() {
  local file
  local pattern=$1
  file=$(rg -i --files-with-matches --no-messages "$pattern" | fzf --preview='bat --style=numbers --color=always {}' --bind ctrl-j:preview-page-up,ctrl-k:preview-page-down) && vim $(echo "$file")
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
