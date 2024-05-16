#!/usr/bin/env bash

select_project() {
    local work_root="$REPO"
    local personal_root="$PERSONAL"
    local dotfiles_root="$DOTFILES"

    declare -A colors=(
        [personal]="\033[32m"
        [work]="\033[33m"
        [dotfiles]="\033[35m"
        [reset]="\033[0m"
    )

    local fzf_height="50%"
    local fzf_output

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
        | fzf --ansi -m -1 --border=rounded --border-label="Repo" --color="border:#808000" --height $fzf_height --expect=ctrl-a
    )

    # Split output into dir and key
    local key=$(head -1 <<<"$fzf_output")
    local dir=$(tail -n +2 <<<"$fzf_output")

    echo "$dir $key"
}

main() {
    local project_dir_key_combo=$(select_project)
    local project_dir=$(awk '{print $1}' <<<"$project_dir_key_combo")
    local pressed_key=$(awk '{print $2}' <<<"$project_dir_key_combo")

    if [ -z "$project_dir" ]; then
        return 0
    fi

    if [ "$pressed_key" = "ctrl-a" ]; then
        local directory=$(basename "$project_dir")
        local session_name=${directory//[: .]/_}
        if [ -z $TMUX ]; then
            if ! tmux has-session -t "$session_name" 2>/dev/null; then
                tmux new-session -s "$session_name" -c "$project_dir"
            fi
            return 0
        fi

        if ! tmux has-session -t "$session_name" 2>/dev/null; then
            tmux new-session -ds "$session_name" -c "$project_dir"
        fi

        tmux switch-client -t $session_name
    else
        cd "$project_dir"
    fi
}

main "$@"
