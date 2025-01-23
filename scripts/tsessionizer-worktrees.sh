#!/usr/bin/env bash

# Define color codes for different project types
declare -A colors=(
    [green]="\033[32m"
    [reset]="\033[0m"
)

# Fetch all available worktrees in the current git directory
get_worktrees_list() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "Not inside a git repository." >&2
        return 1
    fi
    
    # List all worktrees (assuming Git v2.18+)
    git worktree list | awk '{print $1}'
}

# Use fzf to select a worktree directory
select_worktree() {
    local fzf_height="50%"
    
    local worktree_list=$(get_worktrees_list)
    if [ -z "$worktree_list" ]; then
        echo "No worktrees found."
        return 1
    fi

    # Select from the list using fzf
    echo "$worktree_list" | \
    fzf --ansi -m -1 --border=rounded --border-label="Worktrees" --color="border:#5A5F8C"
}

# Create a new tmux window or switch to an existing one
manage_tmux_session() {
    local worktree_path="$1"
    local worktree_name=$(basename "$worktree_path")
    worktree_name=${worktree_name^^}

    # Try to switch to an existing window, or create a new one
    if tmux list-windows -F "#W" | grep -q "^$worktree_name$"; then
        tmux select-window -t "$worktree_name"
    else
        tmux new-window -n "$worktree_name" -c "$worktree_path"
    fi

    # Switch to the new or existing tmux window
    tmux select-window -t "$worktree_name"
    # tmux attach-session -t "$(tmux display-message -p '#S')"
}

# Main function to handle the overall flow
main() {
    local wt_list=$(select_worktree)

    if [ -z "$wt_list" ]; then
        return 0
    fi

    # Manage the tmux session for the selected worktree
    manage_tmux_session "$wt_list"
}

main "$@"
