#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="axteams-one"
REPO_NAME="sp-controllers"

QUERY_ALL='
query($owner: String!, $name: String!, $cursor: String) {
  viewer { login }
  repository(owner: $owner, name: $name) {
    pullRequests(states: OPEN, first: 100, after: $cursor) {
      nodes {
        number
        title
        url
        createdAt
        isDraft
        author { login }
        reviewRequests(first: 20) {
          nodes { requestedReviewer { ... on User { login } } }
        }
        reviews(first: 50) {
          nodes { author { login } state }
        }
      }
    }
  }
}'

QUERY_SINGLE='
query($owner: String!, $name: String!, $number: Int!) {
  viewer { login }
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      number
      title
      url
      createdAt
      isDraft
      author { login }
      reviewRequests(first: 20) {
        nodes { requestedReviewer { ... on User { login } } }
      }
      reviews(first: 50) {
        nodes { author { login } state }
      }
    }
  }
}'

check_pending_reviews() {
    local data
    data=$(gh api graphql -f query="$QUERY_ALL" \
        -f owner="$REPO_OWNER" -f name="$REPO_NAME" 2>/dev/null) || {
        echo "❌ Failed to fetch data"
        return 1
    }

    local my_username
    my_username=$(echo "$data" | jq -r '.data.viewer.login')

    local result
    result=$(echo "$data" | jq --arg me "$my_username" '
        .data.repository.pullRequests.nodes |
        [.[] | select(.author.login != $me and .isDraft == false) |
         select([.reviews.nodes[] | select(.author.login == $me and .state == "APPROVED")] | length == 0) |
         . + {
            requested: ([.reviewRequests.nodes[].requestedReviewer | select(.login == $me)] | length > 0)
         }]
    ')

    local count
    count=$(echo "$result" | jq 'length')

    if [[ "$count" -eq 0 ]]; then
        echo "✅ No PRs need your review"
        return
    fi

    echo "📋 $count PRs need review:"
    echo

    echo "$result" | jq -r '.[] |
        (if .requested then " 🔔" else "" end) as $req |
        "\u001b[38;5;137m  #\(.number) \(.title)\u001b[0m\($req)\n  \u001b[38;5;244m\(.author.login) · \(.createdAt[:10])\u001b[0m\n"'
}

check_specific_pr() {
    local pr_number="$1"

    local data
    data=$(gh api graphql -f query="$QUERY_SINGLE" \
        -f owner="$REPO_OWNER" -f name="$REPO_NAME" \
        -F number="$pr_number" 2>/dev/null) || {
        echo "❌ Could not fetch PR #$pr_number"
        return 1
    }

    local my_username
    my_username=$(echo "$data" | jq -r '.data.viewer.login')

    echo "$data" | jq -r --arg me "$my_username" '
        .data.repository.pullRequest |
        "  \u001b[38;5;137m#\(.number) \(.title)\u001b[0m\n  \u001b[38;5;244m\(.author.login) · \(.createdAt[:10])\u001b[0m\n" +
        if .author.login == $me then "  ⚠️  Your PR"
        elif .isDraft then "  ⚠️  Draft"
        elif ([.reviews.nodes[] | select(.author.login == $me and .state == "APPROVED")] | length) > 0 then "  ✅ Approved"
        else "  ⏳ Needs your review" +
            if ([.reviewRequests.nodes[].requestedReviewer | select(.login == $me)] | length) > 0 then " 🔔" else "" end
        end'
}

if [[ $# -gt 0 ]]; then
    check_specific_pr "$1"
else
    check_pending_reviews
fi
