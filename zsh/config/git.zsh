# -Git-

alias gco='git checkout'
alias ggl='git pull origin $(current_branch)'
alias gsl="git stash list --pretty=format:'%Cblue%gd%Cred: %C(yellow)%s"
alias greset='git reset --hard HEAD'
alias uncommit='git reset --soft HEAD~'
alias gstash='git stash save --include-untracked'
alias gcob='git branch | cut -c 3- | fzf --print0 -1 --border=rounded --height 10% | xargs git checkout'
alias gdb='git branch | cut -c 3- | fzf --print0 -m -1 --border=rounded --height 10% | xargs  -0 -t -o git branch -D'
alias gun='git --no-pager diff --name-only --cached | fzf --print0 -m -1 --border=rounded --height 10% | xargs -0 -t -o git reset'
alias gad='git ls-files -m -o --exclude-standard | fzf --print0 -m -1 --border=rounded --height 10% | xargs -0 -t -o git add'
alias remotebranch="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)    %(align:25,left)%(color:yellow)%(authorname)%(end) %(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"

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

# Better git status with changed lines count in colors
function gst() {
  git status -s | while read mode file; do
    if [[ $mode == "??" ]]; then
      added_lines="??"
      deleted_lines="??"
      mode_color="\033[33m" # Yellow
    else
      added_lines=$(git diff --numstat HEAD "$file" | awk '{print $1}')
      deleted_lines=$(git diff --numstat HEAD "$file" | awk '{print $2}')
      mode_color="\033[32m" # Green
    fi

    printf "${mode_color}%-5s\033[0m %-40s %s ${mode_color}%-8s\033[0m \033[31m%s\033[0m\n" "$mode" "$file" "$(stat -f "%Sm" "$file")" "+$added_lines" "-$deleted_lines"
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
