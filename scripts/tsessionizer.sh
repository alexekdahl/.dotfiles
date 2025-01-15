#!/usr/bin/env bash

# Define color codes for different project types
declare -A colors=(
    [personal]="\033[32m"
    [work]="\033[33m"
    [dotfiles]="\033[35m"
    [reset]="\033[0m"
)

# Fetch all available project directories
get_project_list() {
    local work_root="$REPO"
    local personal_root="$PERSONAL"
    local dotfiles_root="$DOTFILES"

    find "$work_root" "$personal_root" -mindepth 1 -maxdepth 1 -type d
    echo "$dotfiles_root"
}

# Colorize project directories for display in fzf
colorize_projects() {
    local work_root="$REPO"
    local personal_root="$PERSONAL"
    local dotfiles_root="$DOTFILES"

    awk -v work="$work_root" -v personal="$personal_root" -v dotfiles="$dotfiles_root" \
        -v workColor="${colors[work]}" -v personalColor="${colors[personal]}" \
        -v dotfilesColor="${colors[dotfiles]}" -v reset="${colors[reset]}" '
    {
        if ($0 == dotfiles)
            printf "%s%s%s\n", dotfilesColor, $0, reset
        else if (index($0, work) == 1)
            printf "%s%s%s\n", workColor, $0, reset
        else if (index($0, personal) == 1)
            printf "%s%s%s\n", personalColor, $0, reset
    }'
}

# Use fzf to select a project directory
select_project() {
    local fzf_height="50%"
    
    local project_list=$(get_project_list)
    echo "$project_list" | colorize_projects | \
    fzf --ansi -m -1 --border=rounded --border-label="Repo" --color="border:#808000"
}

# Create a new tmux session or attach to an existing one
manage_tmux_session() {
    local project_dir="$1"
    local session_name="$2"

    if [ -z $TMUX ]; then
        if ! tmux has-session -t "$session_name" 2>/dev/null; then
            tmux new-session -d -s "$session_name" -n "CODE" -c "$project_dir"
            if [[ "$session_name" != "_DOTFILES" ]]; then
                tmux new-window -t "$session_name" -n "TEST" -c "$project_dir"
            fi
            tmux select-window -t "$session_name:1"
            tmux attach-session -t "$session_name"
        fi
    else
        if ! tmux has-session -t "$session_name" 2>/dev/null; then
            tmux new-session -d -s "$session_name" -n "CODE" -c "$project_dir"
            if [[ "$session_name" != "_DOTFILES" ]]; then
                tmux new-window -t "$session_name" -n "TEST" -c "$project_dir"
            fi
        fi
        tmux select-window -t "$session_name:1"
        tmux switch-client -t "$session_name"
    fi
}

# Main function to handle the overall flow
main() {
    local project_dir=$(select_project)

    if [ -z "$project_dir" ]; then
        return 0
    fi

    local directory=$(basename "$project_dir")
    local session_name=${directory//[: .]/_}
    session_name=${session_name^^}

    manage_tmux_session "$project_dir" "$session_name"
}

main "$@"
