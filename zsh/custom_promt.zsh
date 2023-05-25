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
GIT_GREEN="%F{82}"
NODE_GREEN_256="%F{34}"
ONE_DARK_PRO_YELLOW="%F{220}"

# Text attributes
BOLD="%{$(tput bold)%}"
UNDERLINE="%{$(tput smul)%}"
REVERSE="%{$(tput smso)%}"

ARROW_COLOR="${GREEN}"

function add_newline() {
  # Get the last command without arguments
  last_command=$(echo "$LAST_OUTPUT" | awk '{print $1}')

  # Add a new line only if the previous command produced output and wasn't 'clear' or your alias 'c'
  if [ -n "$LAST_OUTPUT" ] && [ "$last_command" != "clear" ] && [ "$last_command" != "c" ]; then
      echo ""
  fi
}

function precmd() {
  LAST_OUTPUT=$(fc -ln -1)
   add_newline

  if [ $? -eq 0 ]; then
    ARROW_COLOR="${GREEN}"
  else
    ARROW_COLOR="${RED}"
  fi
}

# Prompt components
function user_prompt() {
  echo "%n"
}

function host_prompt() {
  echo "$%m"
}

function path_prompt() {
  echo "${RED}$(path_icon) %~ ${RESET}"
}

function path_icon() {
  if [[ "${(%):-%~}" == "~" ]]; then
    echo ""
  elif [[ "${(%):-%~}" == "~repo" ]]; then
    echo "${BOLD}${MAGENTA}${RESET}${RED} "
  else
    echo ""
  fi
}

function user_host() {
  echo "${YELLOW}$(user_prompt)@machine${RESET}"
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
  # 
  local branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)

  if [[ -n $branch_name ]]; then
    local untracked_files=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d '[:space:]')
    local unstaged_files=$(git diff --name-status 2>/dev/null | wc -l | tr -d '[:space:]')
    local staged_files=$(git diff --cached --name-status 2>/dev/null | wc -l | tr -d '[:space:]')
    local combined_changes=$((untracked_files + unstaged_files))
    local stashed_changes=$(git stash list 2>/dev/null | wc -l | tr -d '[:space:]')
    local commits_ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    local branch_color="${GIT_GREEN}"

    if [[ $branch_name == "main" || $branch_name == "master" ]]; then
      branch_color="${BOLD}${MAGENTA}"
    fi


    if [[ $stashed_changes -gt 0 ]]; then
      echo -n "${GIT_GREEN}$branch_color$branch_name *$stashed_changes${RESET}"
      # echo -n " ${BLUE}⚑ $stashed_changes${RESET}"
    else
      echo -n "$branch_color$branch_name${RESET}"
    fi

    if [[ $commits_ahead -gt 0 ]]; then
      echo -n "${GREEN}⇡$commits_ahead${RESET}"
    fi

    if [[ $staged_files -gt 0 ]]; then
      echo -n " ${YELLOW}+$staged_files${RESET}"
    fi

    if [[ $unstaged_files -gt 0 ]]; then
      echo -n " ${YELLOW}!$unstaged_files${RESET}"
    fi

    if [[ $untracked_files -gt 0 ]]; then
      echo -n " ${BLUE}!$untracked_files${RESET}"
    fi
  fi
}

function prompt_example() {
  if [[ -f ".nvmrc" || -f "package.json" ]]; then
    echo "${NODE_GREEN_256} $git_branch${RESET}"
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
PROMPT='$(start_arrow) ${BOLD}${BLACK}[${RESET}$(user_host)${BOLD}${BLACK}]${RESET} $(path_prompt)$(git_status_prompt)
$(end_arrow)'

# Enable prompt expansion
setopt PROMPT_SUBST
