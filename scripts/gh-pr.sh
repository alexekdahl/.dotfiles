#!/bin/bash
CACHE_FILE="/tmp/tmux-gh-pr-cache"
CACHE_TTL=1800 # 30 minutes

# Check if cache exists and is recent enough
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TTL ]; then
    cat "$CACHE_FILE"
else
    count=$(gh api "search/issues?q=is:pr+is:open+author:@me" | jq '.items | length')
    echo "$count" > "$CACHE_FILE"
    echo "$count"
fi

