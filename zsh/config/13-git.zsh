# -Git-

alias gco='git checkout'
alias ggl='git pull origin $(current_branch)'
alias gsl="git stash list --pretty=format:'%Cblue%gd%Cred: %C(yellow)%s"
alias greset='git reset --hard HEAD'
alias uncommit='git reset --soft HEAD~'
alias gstash='git stash save --include-untracked'
alias gcob='git branch | cut -c 3- | fzf --print0 -1 --border=rounded --height 10% | xargs --null git checkout'
alias gdb='git branch | cut -c 3- | fzf --print0 -m -1 --border=rounded --height 10% | xargs  -0 -t -o git branch -D'
alias gun='git --no-pager diff --name-only --cached | fzf --print0 -m -1 --border=rounded --height 10% | xargs -0 -t -o git reset'
alias gad='git ls-files -m -o --exclude-standard | fzf --print0 -m -1 --border=rounded --height 10% | xargs -0 -t -o git add'
alias grd='git ls-files -m -o --exclude-standard | fzf --print0 -m -1 --border=rounded --height 40% | xargs -0 -t -o git restore'
alias remotebranch="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)    %(align:25,left)%(color:yellow)%(authorname)%(end) %(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias grebase="git fetch origin master:master && git rebase -i master"
alias gw="git worktree"
alias gws="git worktree list"
alias gwd="git worktree prune"
alias ggp='git push origin $(current_branch) $1'
alias gamend='git commit --amend --no-edit'
alias gcm='git commit -m $1'

# Interactive git diff
function gdiff {
  local preview
  # Avoid spawning a subshell unnecessarily
  preview='[[ $(git ls-files --error-unmatch -- {} 2>/dev/null) ]] && git diff --color=always -- {} || bat --color=always {}'

  local file
  file=$(git ls-files --others --exclude-standard --modified --full-name | 
    fzf --ansi --preview="$preview" --preview-window=right:70%) && vim $file
}

# Interactive git add
function gadd {
  preview="git diff $@ --color=always -- {-1}"
  git ls-files -m -o --exclude-standard | fzf --print0 -m -1 --border=rounded --reverse --ansi --preview $preview | xargs -0 -t -o git add
}

# git commit browser
function glog {
  git log --color=always \
    --pretty=format:"%Cred%h%Creset %Cgreen(%cr) %C(bold blue)<%an> -%C(yellow)%d%Creset %s%Creset" "$@" \
    --abbrev-commit |
  fzf --ansi --reverse --no-sort --tiebreak=index \
      --preview "git show --color=always --name-only {1}" \
      --bind "ctrl-m:execute:git show --color=always {1} | less -R" \
      --bind "ctrl-s:execute:git checkout {1}" 
}

function gst() {
  # Get the list of files and their modes
  git status --porcelain=v1 | while read -r mode file; do
    added_lines=""
    deleted_lines=""
    mod_time=""
    mode_color=""
    
    case "$mode" in
      \?\?)
        # Untracked files
        added_lines="??"
        deleted_lines="??"
        mode_color="\033[33m" # Yellow
        if [[ "$OSTYPE" == "darwin"* ]]; then
          mod_time=$(stat -f "%Sm" "$file")
        else
          mod_time=$(stat -c "%y" "$file" | cut -d '.' -f 1)
        fi
        ;;
      D)
        # Deleted files
        mode_color="\033[31m" # Red
        ;;
      *)
        # Modified or other states
        added_lines=$(git diff --numstat HEAD "$file" 2>/dev/null | awk '{print $1}')
        deleted_lines=$(git diff --numstat HEAD "$file" 2>/dev/null | awk '{print $2}')
        if [[ "$OSTYPE" == "darwin"* ]]; then
          mod_time=$(stat -f "%Sm" "$file")
        else
          mod_time=$(stat -c "%y" "$file" | cut -d '.' -f 1)
        fi
        mode_color="\033[32m" # Green
        ;;
    esac
    
    printf "${mode_color}%-5s\033[0m %-40s %s ${mode_color}%-8s\033[0m \033[31m%s\033[0m\n" "$mode" "$file" "$mod_time" "+$added_lines" "-$deleted_lines"
  done | column -t
}

function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
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
