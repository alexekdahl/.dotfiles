#!/bin/bash
CACHE_FILE="/tmp/tmux-gh-cache"
CACHE_TTL=600 # 10 minutes

# Check if cache exists and is recent enough
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TTL ]; then
    cat "$CACHE_FILE"
else
    count=$(gh api notifications | jq '. | length')
    echo "$count" > "$CACHE_FILE"
    echo "$count"
fi
