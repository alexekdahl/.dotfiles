#!/bin/bash

# Configuration
REPO="axteams-one/sp-controllers"
CACHE_FILE="/tmp/tmux-gh-pr-cache"
CACHE_TTL=600 # 10 minutes

get_pr_review_count() {
    local my_username
    
    # Get username, return 0 if fails
    if ! my_username=$(gh api user --jq '.login' 2>/dev/null); then
        echo "0"
        return 1
    fi
    
    # Get all open PRs with needed data, return 0 if fails
    local prs_data
    if ! prs_data=$(gh pr list --repo "$REPO" --state open --json number,author,isDraft --limit 100 2>/dev/null); then
        echo "0"
        return 1
    fi
    
    # Return 0 if no PRs or invalid JSON
    if [ -z "$prs_data" ] || [ "$prs_data" = "[]" ]; then
        echo "0"
        return 0
    fi
    
    # Filter out PRs created by me and drafts
    local filtered_prs
    if ! filtered_prs=$(echo "$prs_data" | jq --arg username "$my_username" '
        map(select(
            .author.login != $username and 
            .isDraft == false
        ))
    ' 2>/dev/null); then
        echo "0"
        return 1
    fi
    
    local filtered_count
    if ! filtered_count=$(echo "$filtered_prs" | jq '. | length' 2>/dev/null); then
        echo "0"
        return 1
    fi
    
    # If no PRs after filtering, return 0
    if [ "$filtered_count" -eq 0 ]; then
        echo "0"
        return 0
    fi
    
    # Check approval status for filtered PRs
    local pending_count=0
    local pr_numbers
    if ! pr_numbers=$(echo "$filtered_prs" | jq -r '.[].number' 2>/dev/null); then
        echo "0"
        return 1
    fi
    
    while IFS= read -r pr_number; do
        if [ -n "$pr_number" ]; then
            # Check if I've approved this PR (get latest review state)
            local my_review_state
            if my_review_state=$(gh api repos/$REPO/pulls/$pr_number/reviews --jq ".[] | select(.user.login == \"$my_username\") | .state" 2>/dev/null | tail -1); then
                if [ "$my_review_state" != "APPROVED" ]; then
                    ((pending_count++))
                fi
            else
                # If we can't get review status, assume it needs review
                ((pending_count++))
            fi
        fi
    done <<< "$pr_numbers"
    
    echo "$pending_count"
    return 0
}

fetch_and_notify() {
    # Try to fetch PR review count, return cached value if it fails
    if ! new_count=$(get_pr_review_count); then
        # Return cached value if available, otherwise return 0
        [ -f "$CACHE_FILE" ] && cat "$CACHE_FILE" || echo "0"
        return 1
    fi
    
    # Load old count (default to 0 if cache file is missing)
    old_count=0
    [ -f "$CACHE_FILE" ] && old_count=$(cat "$CACHE_FILE")
    
    # Save new count to cache only after successful fetch
    echo "$new_count" > "$CACHE_FILE"
    
    # Notify only if increased or went from 0 to >0
    if (( new_count > old_count )) || (( old_count == 0 && new_count > 0 )); then
        delta=$(( new_count - old_count ))
        notify-send "GitHub PR Reviews" "$delta new PR(s) need your review"
    fi
    
    echo "$new_count"
}

# If cache is still valid, just output cached value
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TTL ]; then
    cat "$CACHE_FILE"
else
    fetch_and_notify
fi
