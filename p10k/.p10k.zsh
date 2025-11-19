#!/usr/bin/env zsh

# ---------------------------------------------------------------------
# Colour variables with descriptive names
#
# Adjust the numeric values below to tweak your colour scheme. Each
# variable name indicates where the colour is used in the prompt.
# ---------------------------------------------------------------------

# Dark grey used for the multiline prompt gap, prefix symbols and ruler.
# Changing this adjusts decorations on multi‑line prompts and the vertical ruler.
typeset -g COLOR_MULTILINE_PREFIX=238

# Green used for “OK” states such as successful prompts and clean Git statuses.
# This affects the default chevron and git segments when there are no warnings or errors.
typeset -g COLOR_PROMPT_OK=70

# Red used for error states and conflicts. When commands fail or Git reports conflicts,
# this draws attention.
typeset -g COLOR_PROMPT_ERROR=160

# Blue for the Vim insert‑mode chevron (VIINS). Predominant colour when editing in insert mode.
typeset -g COLOR_CHEVRON_VIINS=65

# Yellow for the Vim visual‑mode chevron (VIVIS). Highlights the prompt symbol in visual mode.
typeset -g COLOR_CHEVRON_VIVIS=131

# Yellow used when the current user is root.
typeset -g COLOR_CONTEXT_ROOT=178

# Pale yellow for remote and remote‑sudo contexts. Differentiates sessions on remote hosts or via sudo over SSH.
typeset -g COLOR_CONTEXT_REMOTE=180

# Grey for subdued Git meta information and VCS loading state. Neutral colours de‑emphasise less important details.
typeset -g COLOR_NEUTRAL=244

# Colour for directory segments (current working directory).
typeset -g COLOR_DIR=244

# Colours for other segments
typeset -g COLOR_EXECUTION_TIME=101    # command execution time segment
typeset -g COLOR_BACKGROUND_JOBS=70    # background jobs segment
typeset -g COLOR_GO_VERSION=37         # Go version segment
typeset -g COLOR_TIME=66               # time segment
typeset -g COLOR_EXAMPLE=208           # example segment
typeset -g COLOR_DIM=137           # example segment

# Foreground escape sequences for Git status colours, derived from the variables above.
typeset -g FG_GIT_CLEAN="%${COLOR_DIM}F"         # clean statuses
typeset -g FG_GIT_MODIFIED="%${COLOR_DIM}F"  # modified statuses
typeset -g FG_GIT_UNTRACKED="%${COLOR_DIM}F" # untracked statuses
typeset -g FG_GIT_CONFLICTED="%${COLOR_DIM}F" # conflicted statuses
typeset -g FG_GIT_NEUTRAL="%${COLOR_DIM}F"         # neutral/meta statuses

# VCS segment colours for explicit use
typeset -g COLOR_VCS_VISUAL_IDENTIFIER=243        # colour for VCS visual identifier when repo is loaded
typeset -g COLOR_VCS_LOADING_IDENTIFIER=243      # colour for the VCS icon while status is loading
typeset -g COLOR_VCS_CLEAN=243                    # colour for VCS clean foreground
typeset -g COLOR_VCS_UNTRACKED=243                # colour for VCS untracked foreground
typeset -g COLOR_VCS_MODIFIED=243                # colour for VCS modified foreground

# ---------------------------------------------------------------------
# Prompt configuration
# ---------------------------------------------------------------------

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.1 || return

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    prompt_char
    dir
    vcs_joined
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    command_execution_time
    background_jobs
  )

  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      local       meta='%f'
      local      clean="$FG_GIT_CLEAN"
      local   modified="$FG_GIT_MODIFIED"
      local  untracked="$FG_GIT_UNTRACKED"
      local conflicted="$FG_GIT_CONFLICTED"
    else
      local       meta="$FG_GIT_NEUTRAL"
      local      clean="$FG_GIT_NEUTRAL"
      local   modified="$FG_GIT_NEUTRAL"
      local  untracked="$FG_GIT_NEUTRAL"
      local conflicted="$FG_GIT_NEUTRAL"
    fi

    local res

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+="${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=1
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_SHOW_RULER=true
  typeset -g POWERLEVEL9K_RULER_CHAR='─'
  typeset -g POWERLEVEL9K_RULER_FOREGROUND=$COLOR_MULTILINE_PREFIX
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$COLOR_PROMPT_OK
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$COLOR_PROMPT_ERROR
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  # 
  # 
  # typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=' '
  # Set the chevron colour based on Vim mode using descriptive variables.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=$COLOR_CHEVRON_VIINS     # insert mode chevron (blue)
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND=$COLOR_CHEVRON_VIVIS    # visual mode chevron (yellow)

  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$COLOR_DIR
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$COLOR_DIR
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$COLOR_DIR
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=false
  local anchor_files=(
    .bzr .citc .git .hg .node-version .python-version .go-version
    .ruby-version .lua-version .java-version .perl-version .php-version
    .tool-version .shorten_folder_marker .svn .terraform
    CVS Cargo.toml composer.json go.mod package.json stack.yaml
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_PREFIX=':'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$COLOR_VCS_VISUAL_IDENTIFIER
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=$COLOR_VCS_LOADING_IDENTIFIER
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$COLOR_VCS_CLEAN
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$COLOR_VCS_UNTRACKED
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$COLOR_VCS_MODIFIED
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$COLOR_EXECUTION_TIME
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$COLOR_BACKGROUND_JOBS
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$COLOR_CONTEXT_ROOT
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=$COLOR_CONTEXT_REMOTE
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=$COLOR_CONTEXT_REMOTE
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE=''
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE=''
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$COLOR_GO_VERSION
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$COLOR_TIME
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  typeset -g POWERLEVEL9K_EXAMPLE_FOREGROUND=$COLOR_EXAMPLE
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
