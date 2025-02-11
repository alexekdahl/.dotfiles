# ==================================================
# 1. Load Colors and Define Your Custom Prompt Parts
# ==================================================

# Load colors and set terminal
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

# ----------------------------
# 2. Define Precmd and RPROMPT
# ----------------------------
function update_rprompt() {
  RPROMPT='$(time_prompt)'
}

function precmd() {
  update_rprompt
}

# ------------------------------------
# 3. Define Your Custom Prompt Functions
# ------------------------------------
function user_prompt() {
  echo "%n"
}

function host_prompt() {
  echo "%m"
}

function path_prompt() {
  if [[ "${(%):-%~}" == "~" ]]; then
    echo "${RED}${RESET}"
  else
    echo "${RED}%~ ${RESET}"
  fi
}

function time_prompt() {
  echo "${FADED_GREY} %T${RESET}"
}

function user_host() {
  echo "${YELLOW}$(user_prompt)@machine${RESET}"
}

function git_status_prompt() {
  # First, check if we're inside a Git repository.
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  # Get the Git directory.
  # In a normal worktree, this will be something like ../.git/worktrees/<name>
  local git_dir
  git_dir=$(git rev-parse --git-dir 2>/dev/null)

  # If the git_dir does not contain "worktrees", then we’re not inside an active worktree.
  # (This is your “bare root” where the main repo lives.) In that case, skip displaying Git status.
  if [[ "$git_dir" != *worktrees* ]]; then
    return
  fi

  # Retrieve branch name.
  local branch_name
  branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ "$branch_name" == "HEAD" ]]; then
    # Detached HEAD – show short commit hash instead.
    branch_name=$(git rev-parse --short HEAD 2>/dev/null)
    branch_name="DETACHED(${branch_name})"
  fi

  # Choose branch color.
  local branch_color="${GIT_GREEN} "
  if [[ "$branch_name" == "main" || "$branch_name" == "master" ]]; then
    branch_color="${BOLD}${MAGENTA} "
  fi

  # Begin constructing the output string.
  local output="${branch_color}${branch_name}${RESET}"

  # Upstream comparison: only if an upstream exists.
  if git rev-parse --abbrev-ref @{u} &>/dev/null; then
    local commits_ahead
    local commits_behind
    commits_ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    commits_behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
    if [[ $commits_ahead -gt 0 ]]; then
      output+=" ${GREEN}⇡$commits_ahead${RESET}"
    fi
    if [[ $commits_behind -gt 0 ]]; then
      output+=" ${GREEN}⇣$commits_behind${RESET}"
    fi
  fi

  # Count various Git states.
  local untracked_files
  local unstaged_files
  local staged_files
  local stashed_changes
  local has_conflicts

  untracked_files=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d '[:space:]')
  unstaged_files=$(git diff --name-status 2>/dev/null | wc -l | tr -d '[:space:]')
  staged_files=$(git diff --cached --name-status 2>/dev/null | wc -l | tr -d '[:space:]')
  stashed_changes=$(git stash list 2>/dev/null | wc -l | tr -d '[:space:]')
  has_conflicts=$(git ls-files -u 2>/dev/null | wc -l | tr -d '[:space:]')

  if [[ $stashed_changes -gt 0 ]]; then
    output+=" ${GIT_GREEN}*$stashed_changes${RESET}"
  fi

  if [[ $staged_files -gt 0 ]]; then
    output+=" ${YELLOW}+$staged_files${RESET}"
  fi

  if [[ $unstaged_files -gt 0 ]]; then
    output+=" ${YELLOW}!$unstaged_files${RESET}"
  fi

  if [[ $untracked_files -gt 0 ]]; then
    output+=" ${BLUE}?$untracked_files${RESET}"
  fi

  if [[ $has_conflicts -gt 0 ]]; then
    output+=" ${RED}x$has_conflicts${RESET}"
  fi

  # Check for ongoing rebase or merge operations.
  if [[ -n "$git_dir" ]]; then
    local rebase_path="$git_dir/rebase-merge"
    local merge_path="$git_dir/MERGE_HEAD"
    if [[ -d $rebase_path ]]; then
      output+=" ${MAGENTA}REBASING${RESET}"
    fi
    if [[ -f $merge_path ]]; then
      output+=" ${MAGENTA}MERGING${RESET}"
    fi
  fi

  echo -n "$output"
}

function start_arrow() {
  echo "${FADED_GREY}╭─${RESET}"
}

function end_arrow() {
  echo "${FADED_GREY}╰─${ARROW_COLOR}❯ ${RESET}"
}

# --------------------------------------------------
# 4. Build and Set Your Full (Persistent) Prompt
# --------------------------------------------------
PERSISTENT_PROMPT='$(start_arrow) ${BOLD}${FADED_GREY}[${RESET}$(user_host)${BOLD}${FADED_GREY}]${RESET} $(path_prompt)$(git_status_prompt)
$(end_arrow)'

PROMPT=$PERSISTENT_PROMPT
RPROMPT='$(time_prompt)'
setopt PROMPT_SUBST

# Source additional configuration if needed.
source $DOTFILES/zsh/prompt_config.zsh
TRANSIENT_PROMPT_TRANSIENT_PROMPT='${ARROW_COLOR}❯ ${RESET}'
