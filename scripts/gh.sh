#!/bin/bash
CACHE_FILE="/tmp/tmux-gh-cache"
CACHE_TTL=600 # 10 minutes

fetch_and_notify() {
    new_count=$(gh api notifications | jq '. | length')

    # Load old count (default to 0 if cache file is missing)
    old_count=0
    [ -f "$CACHE_FILE" ] && old_count=$(cat "$CACHE_FILE")

    # Save new count to cache
    echo "$new_count" > "$CACHE_FILE"

    # Notify only if increased or went from 0 to >0
    if (( new_count > old_count )) || (( old_count == 0 && new_count > 0 )); then
        delta=$(( new_count - old_count ))
        notify-send "GitHub Notifications" "$delta new notification(s)"
    fi

    echo "$new_count"
}

# If cache is still valid, just output cached value
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TTL ]; then
    cat "$CACHE_FILE"
else
    fetch_and_notify
fi
