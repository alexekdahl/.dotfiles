#!/usr/bin/env bash

# Function to select a project
select_project() {
    # Define directory roots
    local work_root="$HOME/dev/axis/repo"
    local personal_root="$HOME/dev/personal"
    local dotfiles_root="$HOME/.dotfiles"

    # Define colors using associative array for better management
    declare -A colors=(
        [personal]="\033[32m"
        [work]="\033[33m"
        [dotfiles]="\033[35m"
        [reset]="\033[0m"
    )

    local fzf_height="50%"
    local fzf_output

    # Find command with improved readability
    fzf_output=$(
        {
            find "$work_root" "$personal_root" -mindepth 1 -maxdepth 1 -type d
            echo "$dotfiles_root"
        } | awk -v work="$work_root" -v personal="$personal_root" -v dotfiles="$dotfiles_root" \
                -v workColor="${colors[work]}" -v personalColor="${colors[personal]}" \
                -v dotfilesColor="${colors[dotfiles]}" -v reset="${colors[reset]}" '
            {
                if ($0 == dotfiles)
                    printf "%s%s%s\n", dotfilesColor, $0, reset
                else if (index($0, work) == 1)
                    printf "%s%s%s\n", workColor, $0, reset
                else if (index($0, personal) == 1)
                    printf "%s%s%s\n", personalColor, $0, reset
            }' \
        | fzf --ansi -m -1 --border=rounded --height $fzf_height --expect=ctrl-a
    )

    # Split output into dir and key
    local key=$(head -1 <<<"$fzf_output")
    local dir=$(tail -n +2 <<<"$fzf_output")

    echo "$dir $key"
}

# Function to get or generate a session name
get_session_name() {
    local project_dir=$1
    local provided_session_name=$2

    local directory=$(basename "$project_dir")
    local session_name=${provided_session_name:-${directory//[: .]/_}}
    echo "$session_name"
}

# Main script execution
main() {
    local project_dir_key_combo=$(select_project)
    local project_dir=$(awk '{print $1}' <<<"$project_dir_key_combo")
    local pressed_key=$(awk '{print $2}' <<<"$project_dir_key_combo")

    if [ -z "$project_dir" ]; then
        return 0
    fi

    if [ "$pressed_key" = "ctrl-a" ]; then
        local session_name=$(get_session_name "$project_dir" "$1")
        if [[ -z $ZELLIJ ]]; then
            local session=$(zellij list-sessions | grep "$session_name")

            cd "$project_dir" || exit

            if [ -z "$session" ]; then
                local directory=$(basename "$project_dir")
                if [ "$directory" = ".dotfiles" ]; then
                    zellij -s "$session_name" --layout default options --default-cwd "$project_dir"
                else
                    zellij -s "$session_name" --layout code options --default-cwd "$project_dir"
                fi
            else
                zellij a "$session_name"
            fi
            return 0
        fi

        # For Zellij, create new tab or switch to existing one
        zellij action new-tab --layout default --name "$session_name" --cwd "$project_dir"
        zellij action go-to-tab-name "$session_name"
        return 0
    fi

    cd "$project_dir"
}

main "$@"
