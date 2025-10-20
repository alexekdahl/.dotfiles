#!/usr/bin/env python3
import json
import subprocess
import sys

REPO = "axteams-one/sp-controllers"

def run_command(cmd):
    """Run command and return output as string"""
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        return None
    return result.stdout.strip()

def gh_json(cmd):
    """Run gh CLI command and return JSON output"""
    output = run_command(f"gh {cmd}")
    if output:
        try:
            return json.loads(output)
        except json.JSONDecodeError:
            return None
    return None

def check_pending_reviews():
    my_username = run_command("gh api user --jq '.login'")
    if not my_username:
        print("❌ Failed to get username")
        return
    
    print(f"Checking open PRs in {REPO} that need my review...")
    print(f"My username: {my_username}")
    print("=" * 48)
    
    # Get all open PRs
    prs = gh_json(f"pr list --repo {REPO} --state open --json number,title,url,author,createdAt,isDraft,reviewRequests --limit 100")
    
    if not prs:
        print("No open PRs found")
        return
    
    print(f"Found {len(prs)} open PRs\n")
    
    # Filter out my PRs and drafts
    relevant_prs = [pr for pr in prs if pr['author']['login'] != my_username and not pr['isDraft']]
    
    print(f"After filtering out your PRs and drafts: {len(relevant_prs)} PRs")
    
    if not relevant_prs:
        print("✅ No PRs need your review (all remaining are either created by you or drafts)")
        return
    
    print("Checking approval status...")
    pending = []
    
    for pr in relevant_prs:
        reviews = gh_json(f"api repos/{REPO}/pulls/{pr['number']}/reviews")
        if reviews:
            my_reviews = [r for r in reviews if r['user']['login'] == my_username]
            if not any(r['state'] == 'APPROVED' for r in my_reviews):
                pr['my_last_review'] = my_reviews[-1]['state'] if my_reviews else None
                pending.append(pr)
        else:
            # If we can't get reviews, assume it needs review
            pending.append(pr)
    
    print("\nSummary:")
    print("========")
    
    if not pending:
        print("✅ No pending PRs - you have approved all relevant open PRs!")
    else:
        print("📋 PRs that need your review:\n")
        
        for pr in pending:
            # Check if I'm requested as reviewer
            review_requests = pr.get('reviewRequests', [])
            requested = any(r.get('login') == my_username for r in review_requests if r)
            
            created_date = pr['createdAt'][:10]
            
            print(f"\033[33m  #{pr['number']}: {pr['title']}\033[0m{' 🔔 (Review requested)' if requested else ''}")
            print(f"    👤 Author: {pr['author']['login']} | 📅 Created: {created_date}")
            print(f"    🔗 {pr['url']}")
            
            if pr.get('my_last_review'):
                print(f"    Your latest review status: {pr['my_last_review']}")
            print()
        
        print(f"Total: {len(pending)} PRs need your review\n")
        print("Filtered out:")
        print(f"  - {len(prs) - len(relevant_prs)} PRs (your own or drafts)")
        print(f"  - {len(relevant_prs) - len(pending)} PRs (already approved by you)")

def check_specific_pr(pr_number):
    print(f"Checking PR #{pr_number}...")
    print("=" * 25)
    
    # Get my username
    my_username = run_command("gh api user --jq '.login'")
    if not my_username:
        print("❌ Failed to get username")
        return
    
    # Get PR info
    pr_info = gh_json(f"pr view {pr_number} --repo {REPO} --json title,url,author,createdAt,isDraft,reviewRequests")
    
    if not pr_info:
        print(f"❌ Could not fetch PR #{pr_number}")
        return
    
    created_date = pr_info['createdAt'][:10]
    
    print(f"Title: {pr_info['title']}")
    print(f"Author: {pr_info['author']['login']}")
    print(f"Created: {created_date}")
    print(f"URL: {pr_info['url']}\n")
    
    # Check filters
    if pr_info['author']['login'] == my_username:
        print("⚠️  This PR was created by you")
        return
    
    if pr_info['isDraft']:
        print("⚠️  This is a draft PR")
        return
    
    # Check approval status
    reviews = gh_json(f"api repos/{REPO}/pulls/{pr_number}/reviews")
    my_reviews = [r for r in reviews if r['user']['login'] == my_username] if reviews else []
    
    if any(r['state'] == 'APPROVED' for r in my_reviews):
        print("✅ You have already approved this PR")
    else:
        print("⏳ You have not approved this PR yet")
        
        # Check if requested
        review_requests = pr_info.get('reviewRequests', [])
        if any(r.get('login') == my_username for r in review_requests if r):
            print("🔔 You are specifically requested as a reviewer")
        
        # Show last review if any
        if my_reviews:
            print(f"\nYour latest review status: {my_reviews[-1]['state']}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        check_specific_pr(sys.argv[1])
    else:
        check_pending_reviews()
