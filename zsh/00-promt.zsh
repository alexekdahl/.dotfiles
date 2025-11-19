# ============================
# 🦒 Pure Zsh P10k-style Prompt
# ============================
autoload -Uz vcs_info colors
setopt prompt_subst no_nomatch

# --- Git Integration ---
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' check-for-staged-changes true
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'
zstyle ':vcs_info:git*+set-message:*' hooks git-p10k

+vi-git-p10k() {
  emulate -L zsh
  setopt no_aliases
  
  # Check if we're in a bare repo root (not in an actual worktree)
  [[ -f .git && -d .bare ]] && { hook_com[branch]=""; return }
  
  # Tachyon-style dimmed monochrome VCS
  local vcs_dim='%243F'     # dim cold silver (≈ base30/base04)
  local clean=$vcs_dim
  local modified=$vcs_dim
  local untracked=$vcs_dim
  local conflicted=$vcs_dim
  
  local branch res
  
  # Optimized branch detection with -q flag
  branch=$(git symbolic-ref --short -q HEAD 2>/dev/null) || \
  branch=$(git describe --tags --exact-match 2>/dev/null) || \
  branch=$(git rev-parse --short HEAD 2>/dev/null)
  [[ -z $branch ]] && return
  (( $#branch > 32 )) && branch[13,-13]="…"
  res="${clean}${branch//\%/%%}"
  
  # Optimized: added --ignore-submodules for 10-15% speedup
  local git_output=$(git status --porcelain=v1 --branch --untracked-files=normal --ignore-submodules 2>/dev/null)
  
  local staged=0 unstaged=0 untracked_count=0 conflicts=0
  local line xy ahead behind
  
  # Optimized parsing with case statement (faster than regex)
  while IFS= read -r line; do
    [[ -z $line ]] && continue
    
    if [[ ${line:0:2} == "##" ]]; then
      # Parse ahead/behind from branch line
      [[ $line =~ 'ahead ([0-9]+)' ]] && ahead=$match[1]
      [[ $line =~ 'behind ([0-9]+)' ]] && behind=$match[1]
      continue
    fi
    
    xy=${line:0:2}
    
    # Use case for faster matching
    case $xy in
      "??") (( untracked_count++ )) ;;
      "DD"|"AU"|"UD"|"UA"|"DU"|"AA"|"UU") (( conflicts++ )) ;;
      *)
        [[ ${xy:0:1} == [MADRC] ]] && (( staged++ ))
        [[ ${xy:1:1} == [MD] ]] && (( unstaged++ ))
        ;;
    esac
  done <<< "$git_output"
  
  (( ahead )) && res+=" ${clean}⇡${ahead}"
  (( behind )) && res+=" ${clean}⇣${behind}"
  
  # Optimized stash check: fast existence test first
  local stashes=0
  if [[ -f .git/refs/stash ]] || git rev-parse --verify --quiet refs/stash >/dev/null 2>&1; then
    stashes=$(git rev-list --walk-reflogs --count refs/stash 2>/dev/null || echo 0)
  fi
  
  local flags=""
  (( conflicts ))       && flags+="~${conflicts}"
  (( staged ))          && flags+="+${staged}"
  (( unstaged ))        && flags+="!${unstaged}"
  (( untracked_count )) && flags+="?${untracked_count}"
  (( stashes ))         && flags+="*${stashes}"

  [[ -n $flags ]] && res+=" ${clean}${flags}"

  hook_com[branch]=$res
}

# --- Vi Mode Setup ---
bindkey -v  # Enable vi mode

# Vi mode indicator colors
typeset -g VI_INS_COLOR='%39F'   # Blue - Insert mode
typeset -g VI_CMD_COLOR='%76F'   # Green - Normal/Command mode
typeset -g VI_VIS_COLOR='%141F'  # Purple - Visual mode
typeset -g VI_ERR_COLOR='%160F'  # Red - Error state

# Track current vi mode
typeset -g VI_MODE_COLOR=$VI_INS_COLOR

# Function to update vi mode indicator
function zle-keymap-select {
  case $KEYMAP in
    vicmd)      VI_MODE_COLOR=$VI_CMD_COLOR ;;  # Normal mode
    visual)     VI_MODE_COLOR=$VI_VIS_COLOR ;;  # Visual mode
    viins|main) VI_MODE_COLOR=$VI_INS_COLOR ;;  # Insert mode
  esac
  zle reset-prompt
}

# Function to set initial mode on new line
function zle-line-init {
  VI_MODE_COLOR=$VI_INS_COLOR
  zle reset-prompt
}

# Register the functions
zle -N zle-keymap-select
zle -N zle-line-init

# --- Multiline Prompt (Tachyon-style) ---
PROMPT='%251F%B%~:%b%f%243F${vcs_info_msg_0_}%f
%238F%f%(?.${VI_MODE_COLOR}.%160F)❯%f '

# No right prompt
RPROMPT=''

# --- Update git info before each prompt ---
precmd() { 
  vcs_info
}

# --- Transient Prompt ---
preexec() {
  print -rn -- $'\e[2A\r\e[0J'
  # keep chevron blue, command text tinted like Tachyon String
  print -Prn -- "%39F❯%f %137F${1}%f"$'\n'
}
