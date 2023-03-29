# -Fzf-

function ff() {
  local file
  file=$(fzf --preview='bat --style=numbers --color=always {}' --bind ctrl-j:preview-page-up,ctrl-k:preview-page-down) && vim $(echo "$file")
}

# -Git-

# Interactive git diff
function gdiff {
  local preview
  preview="git diff $@ --color=always -- {-1}"
  local file
  file=$(git ls-files --others --exclude-standard --modified --full-name | fzf -m --ansi --preview $preview --bind ctrl-j:preview-page-up,ctrl-l:preview-page-down) && vim $(echo "$file")
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

# Better git status
function gst() {
  git status -s | while read mode file; do
      printf "\033[32m%-5s\033[0m %-40s %s\n" "$mode" "$file" "$(stat -f "%Sm" "$file")"
  done | column -t
}

# grab current branch head
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
}

function check_protected_branch() {
  local protected_branch_regex='^(master|main)$'
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  if [[ $branch =~ $protected_branch_regex ]]; then
    echo -ne "\033[1;33mYou're about to push to a protected branch ($branch), is that what you intended? [y|n]: \033[0m"
    read input

    if [[ $input =~ ^[Yy]$ ]]; then
      return 0 # protected branch
    else
      return 1 # not protected branch
    fi
  fi

  return 0 # not protected branch
}

function ggp() {
  if check_protected_branch; then
    git push origin $(current_branch) $1
  else
    echo "Push canceled."
  fi
}

function gamend() {
  if check_protected_branch; then
    git commit --amend --no-edit
  else
    echo "Commit canceled."
  fi
}

function gamendm() {
  if check_protected_branch; then
    git commit --amend -m $1
  else
    echo "Commit canceled."
  fi
}

function gcm() {
  if check_protected_branch; then
    git commit -m $1
  else
    echo "Commit canceled."
  fi
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

function git-check() {
  author_name=$(git config --get user.name)
  if [ -z "$author_name" ]; then
    echo "Error: No user.name found in your .gitconfig"
    return 1
  fi

  git log --author="$author_name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "Added lines: %s, Removed lines: %s, Total lines: %s\n", add, subs, loc }'
}

# -Docker-

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

# run npm script
function nps() {
  local script
  script=$(cat package.json | jq -r '.scripts | keys[] ' | sort | fzf --print0 -m -1 --border=rounded --height 10%) && npm run $(echo "$script")
}

function goodmorning () {
  today &&
  simp &&
  colima start &&
  dstart;
}

function goodbye () {
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
