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
      --pretty=format:"%Cred%h%Creset %Cgreen(%cr) %C(bold blue)<%an> -%C(yellow)%d%Creset %s  %Creset" "$@" \
      --abbrev-commit |
  fzf --ansi --reverse --preview "git show --color=always --name-only {1}" \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
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

function git-stats() {
  # ANSI color codes
  BOLD="\033[1m"
  GREEN="\033[32m"
  CYAN="\033[36m"
  RESET="\033[0m"

  author_name=$1
  total_lines=$(git ls-files | xargs wc -l | tail -n 1 | awk '{print $1}')
  my_lines=$(git ls-files | parallel -j+0 "git blame --line-porcelain {} | grep -F \"author ${author_name}\" | wc -l" | awk '{sum += $1} END {print sum}')
  total_commits=$(git rev-list --count HEAD)
  my_commits=$(git rev-list --count HEAD --author="$author_name")
  lines_percentage=$(echo "scale=2; $my_lines / $total_lines * 100" | bc)
  commits_percentage=$(echo "scale=2; $my_commits / $total_commits * 100" | bc)
  top_3=$(git log --pretty=format:'%aN' | sort | uniq -c | sort -rn | head -3)

  echo -e "${BOLD}${GREEN}Git Repository Statistics:${RESET}"
  echo -e "${BOLD}${CYAN}Total lines in repo:${RESET} $total_lines"
  echo -e "${BOLD}${CYAN}Lines added by you:${RESET} $my_lines"
  echo -e "${BOLD}${CYAN}Total commits:${RESET} $total_commits"
  echo -e "${BOLD}${CYAN}Your commits:${RESET} $my_commits"
  echo -e "${BOLD}${CYAN}Your lines (percentage):${RESET} $lines_percentage%"

  echo -e "\n${BOLD}${CYAN}Top 3 contributors by commit count:${RESET}\n$top_3"

  echo -e "\n${BOLD}${CYAN}Line percentages for top 3 contributors:${RESET}"
  echo "$top_3" | while read -r line; do
    contributor="$(echo "$line" | awk '{for (i=2; i<=NF; i++) printf $i (i<NF?" ":"")}')"
    contrib_lines=$(git ls-files | parallel -j+0 "git blame --line-porcelain {} | grep -F \"author ${contributor}\" | wc -l" | awk '{sum += $1} END {print sum}')
    if [ -z "$contrib_lines" ]; then
      contrib_lines=0
    fi
    contrib_lines_percentage=$(echo "scale=2; $contrib_lines / $total_lines * 100" | bc)
    echo -e "${BOLD}${CYAN}Lines added by ${contributor}:${RESET} $contrib_lines (${contrib_lines_percentage}%)"
  done
}

