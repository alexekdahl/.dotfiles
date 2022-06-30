#  --------------------------------------------------------------------------------------------------------------------
#  88888888888--88--------88--888b------88----,ad8888ba,--888888888888--88----,ad8888ba,----888b------88---ad88888ba---
#  88-----------88--------88--8888b-----88---d8"'----`"8b------88-------88---d8"'----`"8b---8888b-----88--d8"-----"8b--
#  88-----------88--------88--88-`8b----88--d8'----------------88-------88--d8'--------`8b--88-`8b----88--Y8,----------
#  88aaaaa------88--------88--88--`8b---88--88-----------------88-------88--88----------88--88--`8b---88--`Y8aaaaa,----
#  88"""""------88--------88--88---`8b--88--88-----------------88-------88--88----------88--88---`8b--88----`"""""8b,--
#  88-----------88--------88--88----`8b-88--Y8,----------------88-------88--Y8,--------,8P--88----`8b-88----------`8b--
#  88-----------Y8a.----.a8P--88-----`8888---Y8a.----.a8P------88-------88---Y8a.----.a8P---88-----`8888--Y8a-----a8P--
#  88------------`"Y8888Y"'---88------`888----`"Y8888Y"'-------88-------88----`"Y8888Y"'----88------`888---"Y88888P"---
#  --------------------------------------------------------------------------------------------------------------------
#  --------------------------------------------------------------------------------------------------------------------

# -Fzf-

function ff() {
  local file
  file=$(fzf --preview='bat --style=numbers --color=always {}' --bind ctrl-j:preview-page-up,ctrl-k:preview-page-down) && vim $(echo "$file")
}

# -Git-

# Interactive git diff
function gdiff {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview --bind ctrl-j:preview-page-up,ctrl-l:preview-page-down
}

# Interactive git add
function gadd {
  preview="git diff $@ --color=always -- {-1}"
  git ls-files -m -o --exclude-standard | fzf --print0 -m -1 --border=rounded --reverse --ansi --preview $preview --bind ctrl-j:preview-page-up,ctrl-l:preview-page-down | xargs -0 -t -o git add
}

# git commit browser
function glog {
  git log --color=always \
      --pretty=format:"%Cred%h%Creset %Cgreen(%cr) %C(bold blue)<%an> -%C(yellow)%d%Creset %s  %Creset" "$@" \
      --abbrev-commit |
  fzf --ansi --reverse --preview "git show --color=always --name-only {1}" \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# grab current branch head
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

# -Docker-

# start containers for phoenix
function dstart(){
	docker run --name some-mongo -p 27017:27017 --rm -d mongo:4.0.26&&
	docker run --name some-redis -p 6379:6379 --rm -d redis:6.2.5&&
	docker run --name some-rabbit -p 5672:5672 --rm -d rabbitmq:3.6-management-alpine&&
	docker run --name august-aws-dynamodb-local -p 8000:8000 --rm -d amazon/dynamodb-local&&
	docker ps --format ‘{{.Names}}’;
}

# Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf --print0 -m -1 --border=rounded --height 10% -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# Select a running docker container to enter shell
function dbash() {
  local cid
  cid=$(docker ps --format "{{ .ID }}\t{{ .Names }}\t{{ .Image }}" | sed 1d | fzf --print0 -m -1 --border=rounded --height 10% -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker exec -it "$cid" env TERM=xterm-256color bash
}

# -Misc-

# start up time for shell
function timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
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

# run npm script
function nps() {
  local script
  script=$(cat package.json | jq -r '.scripts | keys[] ' | sort | fzf --print0 -m -1 --border=rounded --height 10%) && npm run $(echo "$script")
}


# nvm autouse
function nvm_autouse() {
  if [[ -f ".nvmrc" ]]; then
    nvm use
  fi
}