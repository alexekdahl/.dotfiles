# -Docker-

alias dils='docker image ls'
alias dps='docker ps'
alias dprune='docker volume prune --force'
alias dstop='docker kill $(docker ps -q)'
alias dkill='docker rmi $(docker images -a -q)'

# Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf --print0 -m -1 --border=rounded --height 10% -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# Select a running docker container to enter shell
function dbash() {
  local cid
  cid=$(docker ps --format "{{ .ID }}\t{{ .Names }}\t{{ .Image }}" | fzf --print0 -m -1 --border=rounded --height 15% -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker exec -it "$cid" env TERM=xterm-256color sh
}

