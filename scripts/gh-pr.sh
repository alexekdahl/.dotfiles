#!/bin/bash
CACHE_FILE="/tmp/tmux-gh-pr-cache"
CACHE_TTL=1800 # 30 minutes

# Check if cache exists and is recent enough
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TTL ]; then
    cat "$CACHE_FILE"
else
    # Try to fetch PR data, return cached value if it fails
    if ! pr_data=$(gh api "search/issues?q=is:pr+is:open+author:@me" 2>/dev/null); then
        [ -f "$CACHE_FILE" ] && cat "$CACHE_FILE" || echo "0"
        exit 0
    fi
    
    # Parse the count only if we got valid data
    if ! count=$(echo "$pr_data" | jq '.items | length' 2>/dev/null); then
        [ -f "$CACHE_FILE" ] && cat "$CACHE_FILE" || echo "0"
        exit 0
    fi
    
    # Save to cache only after successful fetch and parse
    echo "$count" > "$CACHE_FILE"
    echo "$count"
fi
