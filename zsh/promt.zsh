#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# Custom Pure-like ZSH theme with:
#  - Full path from ~
#  - No .bare visibility
#  - No VCS info inside .bare
#  - Custom repo display without Git root
# ------------------------------------------------------------------------------

setopt prompt_subst
autoload -Uz vcs_info

# vcs_info config
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' formats "" "%s:%b" "%u%c"
zstyle ':vcs_info:*:*' actionformats "" "%s:%b" "%u%c"
zstyle ':vcs_info:*:*' nvcsformats "" "" ""

# ---- helper: fast git dirty check -------------------------------------------
git_dirty() {
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    command git diff --quiet --ignore-submodules HEAD &>/dev/null
    [ $? -eq 1 ] && echo "*"
}

# ---- helper: full path from ~ -----------------------------------------------
path_from_home() {
    print -P "%~"
}

# ---- helper: detect .bare folder --------------------------------------------
is_bare_dir() {
    [[ $PWD == */.bare(|/*) ]]
}

# ---- repo info (no .bare root, no git path magic) ---------------------------
repo_information() {
    local path=$(path_from_home)
    local git_branch=${vcs_info_msg_1_}
    local git_flags="$(git_dirty) $vcs_info_msg_2_"

    print -P "%F{blue}${path}%f %F{8}${git_branch}${git_flags}%f"
}

# ---- exec time ---------------------------------------------------------------
cmd_exec_time() {
    local stop=$(date +%s)
    local start=${cmd_timestamp:-$stop}
    local elapsed=$((stop - start))
    [ $elapsed -gt 5 ] && echo ${elapsed}s
}

preexec() {
    cmd_timestamp=$(date +%s)
}

# ---- precmd: final prompt renderer ------------------------------------------
precmd() {
    setopt localoptions nopromptsubst

    if is_bare_dir; then
        # No VCS info inside .bare
        print -P "\n%F{blue}$(path_from_home)%f %F{yellow}$(cmd_exec_time)%f"
        unset cmd_timestamp
        return
    fi

    vcs_info
    print -P "\n$(repo_information) %F{yellow}$(cmd_exec_time)%f"
    unset cmd_timestamp
}

# ---- prompt characters -------------------------------------------------------
PROMPT="%(?.%F{magenta}.%F{red})❯%f "
RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"

# ------------------------------------------------------------------------------
# End of theme
# ------------------------------------------------------------------------------
