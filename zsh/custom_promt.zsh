# Load colors
autoload -U colors && colors
export TERM=xterm-256color

# Reset
RESET="%{$reset_color%}"

# Foreground colors
BLACK="%{$fg[black]%}"
RED="%{$fg[red]%}"
GREEN="%{$fg[green]%}"
YELLOW="%{$fg[yellow]%}"
BLUE="%{$fg[blue]%}"
MAGENTA="%{$fg[magenta]%}"
CYAN="%{$fg[cyan]%}"
WHITE="%{$fg[white]%}"
GREY="%{$fg[black,bold]%}"
FADED_GREY="%F{240}"
GIT_GREEN="%F{76}"
NODE_GREEN_256="%F{34}"
ONE_DARK_PRO_YELLOW="%F{220}"
GOLANG_BLUE="%F{32}"

# One Dark Pro Colors
ODP_BACKGROUND="%F{235}"
ODP_FOREGROUND="%F{216}"
ODP_COMMENT="%F{59}"
ODP_CYAN="%F{80}"
ODP_GREEN="%F{114}"
ODP_ORANGE="%F{173}"
ODP_PINK="%F{168}"
ODP_PURPLE="%F{176}"
ODP_RED="%F{167}"
ODP_YELLOW="%F{180}"

# Text attributes
BOLD="%{$(tput bold)%}"
UNDERLINE="%{$(tput smul)%}"
REVERSE="%{$(tput smso)%}"

ARROW_COLOR="${GREEN}"

# Function to update RPROMPT
function update_rprompt() {
  RPROMPT='$(time_prompt)'
}

function add_newline() {
 # Get the last command without arguments
 local last_command=$(echo "$LAST_OUTPUT" | awk '{print $1}')

 # Add a new line only if the previous command produced output and wasn't 'clear' or your alias 'c'
 if [ -n "$LAST_OUTPUT" ] && [ "$last_command" != "clear" ] && [ "$last_command" != "c" ]; then
     echo ""
 fi
}

function precmd() {
  LAST_OUTPUT=$(fc -ln -1)
  add_newline
  update_rprompt
}

# Prompt components
function user_prompt() {
  echo "%n"
}

function host_prompt() {
  echo "$%m"
}

function path_prompt() {
  if [[ "${(%):-%~}" == "~" ]]; then
    echo "${RED}${RESET}"
  else
    echo "${RED}%~ ${RESET}"
  fi
}

function path_icon() {
  if [[ "${(%):-%~}" == "~" ]]; then
    echo "${RED}${RESET}"
  fi
}

function time_prompt() {
  echo "${FADED_GREY} %T${RESET}"
}

function user_host() {
  echo "${YELLOW}$(user_prompt)@machine${RESET}"
}

function language_folder() {
  if [[ -f ".nvmrc" || -f "package.json" ]]; then
    echo "${NODE_GREEN_256} ${RESET}"
  elif [[ -f "go.mod" ]]; then
    echo "${GOLANG_BLUE} ${RESET}"
  else
  fi

}
function node_version_prompt() {
  if [[ -f ".nvmrc" || -f "package.json" ]]; then
    echo "${NODE_GREEN_256} $(node -v)${RESET}"
  fi
}

function go_version_prompt() {
  if [[ -f "go.mod" ]]; then
    echo "${GOLANG_BLUE} $(go version | awk '{print $3}' | cut -c3-)${RESET}"
  fi
}

function commits_not_pushed() {
  local branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)

  if [[ -n $branch_name ]]; then
    local commits_diff=$(git rev-list --count $branch_name ^$remote_name 2>/dev/null)

    if [[ $commits_diff -gt 0 ]]; then
      echo -n " ${MAGENTA}⇡$commits_diff${RESET}"
    fi
  fi
}

function git_status_prompt() {
  local branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $branch_name ]]; then
  # Capture various git statuses
    local commits_ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    local commits_behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
    local untracked_files=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d '[:space:]')
    local unstaged_files=$(git diff --name-status 2>/dev/null | wc -l | tr -d '[:space:]')
    local staged_files=$(git diff --cached --name-status 2>/dev/null | wc -l | tr -d '[:space:]')
    local stashed_changes=$(git stash list 2>/dev/null | wc -l | tr -d '[:space:]')
    local has_conflicts=$(git ls-files -u 2>/dev/null | wc -l | tr -d '[:space:]')
    local rebase=$(git rev-parse --git-path "rebase-merge" 2> /dev/null)
    local merge=$(git rev-parse --git-path "MERGE_HEAD" 2> /dev/null)

    local branch_color="${GIT_GREEN} "

    if [[ $branch_name == "main" || $branch_name == "master" ]]; then
      branch_color="${BOLD}${MAGENTA} "
    fi
    if [[ $stashed_changes -gt 0 ]]; then
      echo -n "${GIT_GREEN}$branch_color$branch_name *$stashed_changes${RESET}"
    else
      echo -n "$branch_color$branch_name${RESET}"
    fi

    # Commits ahead or behind
    if [[ $commits_ahead -gt 0 ]]; then
      echo -n "${GREEN}⇡$commits_ahead${RESET}"
    fi
    if [[ $commits_behind -gt 0 ]]; then
      echo -n "${GREEN}⇣$commits_behind${RESET}"
    fi

    # File statuses
    if [[ $staged_files -gt 0 ]]; then
      echo -n " ${YELLOW}+$staged_files${RESET}"
    fi
    if [[ $unstaged_files -gt 0 ]]; then
      echo -n " ${YELLOW}!$unstaged_files${RESET}"
    fi
    if [[ $untracked_files -gt 0 ]]; then
      echo -n " ${BLUE}?$untracked_files${RESET}"
    fi

    # Conflicts, rebasing, and merging
    if [[ $has_conflicts -gt 0 ]]; then
      echo -n " ${RED}x$has_conflicts${RESET}"
    fi
    if [[ -d $rebase ]]; then
      echo -n " ${MAGENTA}REBASING${RESET}"
    fi
    if [[ -f $merge ]]; then
      echo -n " ${MAGENTA}MERGING${RESET}"
    fi
  fi
}

function start_arrow() {
  echo "${FADED_GREY}╭─${RESET}"
}

function end_arrow() {
  echo "${FADED_GREY}╰─${ARROW_COLOR}❯ ${RESET}"
}

function time_prompt() {
  echo "${FADED_GREY} %T${RESET}"
}

# Build prompt
PROMPT='$(start_arrow) ${BOLD}${FADED_GREY}[${RESET}$(user_host)${BOLD}${FADED_GREY}]${RESET} $(path_prompt)$(git_status_prompt)
$(end_arrow)'

# Enable prompt expansion
setopt PROMPT_SUBST
