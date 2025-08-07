#!/bin/bash

# Configuration
REPO="axteams-one/sp-controllers"
MY_USERNAME=$(gh api user --jq '.login')

# Function to check all open PRs that I haven't approved (excluding my own and drafts)
check_my_pending_reviews() {
    echo "Checking open PRs in $REPO that need my review..."
    echo "My username: $MY_USERNAME"
    echo "================================================"
    
    # Get all open PRs with all needed data in one API call
    echo "Fetching PR data..."
    prs_data=$(gh pr list --repo "$REPO" --state open --json number,title,url,author,createdAt,isDraft,reviewRequests --limit 100)
    
    if [ -z "$prs_data" ] || [ "$prs_data" = "[]" ]; then
        echo "No open PRs found"
        return
    fi
    
    total_prs=$(echo "$prs_data" | jq '. | length')
    echo "Found $total_prs open PRs"
    echo ""
    
    # Filter out PRs created by me and drafts
    filtered_prs=$(echo "$prs_data" | jq --arg username "$MY_USERNAME" '
        map(select(
            .author.login != $username and 
            .isDraft == false
        ))
    ')
    
    filtered_count=$(echo "$filtered_prs" | jq '. | length')
    echo "After filtering out your PRs and drafts: $filtered_count PRs"
    
    if [ "$filtered_count" -eq 0 ]; then
        echo "✅ No PRs need your review (all remaining are either created by you or drafts)"
        return
    fi
    
    # Now get review status for the filtered PRs (batch API call)
    echo "Checking approval status..."
    
    pending_prs=()
    pr_details=()
    
    # Extract PR numbers for batch review checking
    pr_numbers=$(echo "$filtered_prs" | jq -r '.[].number')
    
    while IFS= read -r pr_number; do
        if [ -n "$pr_number" ]; then
            # Check if I've approved this PR
            my_review_state=$(gh api repos/$REPO/pulls/$pr_number/reviews --jq ".[] | select(.user.login == \"$MY_USERNAME\") | .state" 2>/dev/null | tail -1)
            
            if [ "$my_review_state" != "APPROVED" ]; then
                pending_prs+=("$pr_number")
                
                # Get the PR details from our filtered data
                pr_detail=$(echo "$filtered_prs" | jq --arg num "$pr_number" '.[] | select(.number == ($num | tonumber))')
                pr_details+=("$pr_detail")
            fi
        fi
    done <<< "$pr_numbers"
    
    echo ""
    echo "Summary:"
    echo "========"
    
    if [ ${#pending_prs[@]} -eq 0 ]; then
        echo "✅ No pending PRs - you have approved all relevant open PRs!"
    else
        echo "📋 PRs that need your review:"
        echo ""
        
        for i in "${!pending_prs[@]}"; do
            pr_number="${pending_prs[$i]}"
            pr_info="${pr_details[$i]}"
            
            title=$(echo "$pr_info" | jq -r '.title')
            url=$(echo "$pr_info" | jq -r '.url')
            author=$(echo "$pr_info" | jq -r '.author.login')
            created=$(echo "$pr_info" | jq -r '.createdAt' | cut -d'T' -f1)
            
            # Check if I'm specifically requested as reviewer
            am_i_requested=$(echo "$pr_info" | jq --arg username "$MY_USERNAME" -r '
                if (.reviewRequests // []) | map(select(.login == $username)) | length > 0 then
                    " 🔔 (Review requested)"
                else
                    ""
                end
            ')
            
            echo "  #$pr_number: $title$am_i_requested"
            echo "    👤 Author: $author | 📅 Created: $created"
            echo "    🔗 $url"
            echo ""
        done
        
        echo "Total: ${#pending_prs[@]} PRs need your review"
        echo ""
        echo "Filtered out:"
        echo "  - $(($total_prs - $filtered_count)) PRs (your own or drafts)"
        echo "  - $(($filtered_count - ${#pending_prs[@]})) PRs (already approved by you)"
    fi
}

# Function to check specific PR
check_specific_pr() {
    local pr_number="$1"
    echo "Checking PR #$pr_number..."
    echo "========================="
    
    # Get PR info in one call
    pr_info=$(gh pr view "$pr_number" --repo "$REPO" --json title,url,author,createdAt,isDraft,reviewRequests 2>/dev/null)
    
    if [ -z "$pr_info" ]; then
        echo "❌ Could not fetch PR #$pr_number"
        return 1
    fi
    
    title=$(echo "$pr_info" | jq -r '.title')
    url=$(echo "$pr_info" | jq -r '.url')
    author=$(echo "$pr_info" | jq -r '.author.login')
    created=$(echo "$pr_info" | jq -r '.createdAt' | cut -d'T' -f1)
    is_draft=$(echo "$pr_info" | jq -r '.isDraft')
    
    echo "Title: $title"
    echo "Author: $author"
    echo "Created: $created"
    echo "URL: $url"
    echo ""
    
    # Check filters
    if [ "$author" = "$MY_USERNAME" ]; then
        echo "⚠️  This PR was created by you"
        return
    fi
    
    if [ "$is_draft" = "true" ]; then
        echo "⚠️  This is a draft PR"
        return
    fi
    
    # Check approval status
    my_review_state=$(gh api repos/$REPO/pulls/$pr_number/reviews --jq ".[] | select(.user.login == \"$MY_USERNAME\") | .state" 2>/dev/null | tail -1)
    
    if [ "$my_review_state" = "APPROVED" ]; then
        echo "✅ You have already approved this PR"
    else
        echo "⏳ You have not approved this PR yet"
        
        # Show if I'm requested
        am_i_requested=$(echo "$pr_info" | jq --arg username "$MY_USERNAME" -r '
            if (.reviewRequests // []) | map(select(.login == $username)) | length > 0 then
                "yes"
            else
                "no"
            end
        ')
        
        if [ "$am_i_requested" = "yes" ]; then
            echo "🔔 You are specifically requested as a reviewer"
        fi
        
        # Show my review history if any
        if [ -n "$my_review_state" ]; then
            echo ""
            echo "Your latest review status: $my_review_state"
        fi
    fi
}

# Main execution
if [ $# -eq 0 ]; then
    check_my_pending_reviews
elif [ $# -eq 1 ]; then
    check_specific_pr "$1"
else
    echo "Usage: $0 [PR_NUMBER]"
    echo "  No arguments: Show open PRs needing your review (excludes your own PRs and drafts)"
    echo "  PR_NUMBER: Check specific PR status"
    exit 1
fi
