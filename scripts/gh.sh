#!/bin/bash
CACHE_FILE="/tmp/tmux-gh-cache"
CACHE_TTL=600 # 10 minutes

fetch_and_notify() {
    # Try to fetch notifications, return cached value if it fails
    if ! notifications=$(gh api notifications 2>/dev/null); then
        # Return cached value if available, otherwise return 0
        [ -f "$CACHE_FILE" ] && cat "$CACHE_FILE" || echo "0"
        return 1
    fi
    
    # Parse the count only if we got valid data
    if ! new_count=$(echo "$notifications" | jq '. | length' 2>/dev/null); then
        # Return cached value if jq fails
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
