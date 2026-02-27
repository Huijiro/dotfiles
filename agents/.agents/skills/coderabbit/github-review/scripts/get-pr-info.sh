#!/usr/bin/env bash
# Prints PR number, URL, title, repo owner, and repo name as JSON.
# Usage: eval "$(./get-pr-info.sh)"

set -euo pipefail

PR_JSON=$(gh pr view --json number,url,title --jq '{number,url,title}')
REPO_JSON=$(gh repo view --json owner,name --jq '{owner: .owner.login, name: .name}')

PR_NUMBER=$(echo "$PR_JSON" | jq -r '.number')
PR_TITLE=$(echo "$PR_JSON"  | jq -r '.title')
PR_URL=$(echo "$PR_JSON"    | jq -r '.url')
OWNER=$(echo "$REPO_JSON"   | jq -r '.owner')
REPO=$(echo "$REPO_JSON"    | jq -r '.name')

echo "export PR_NUMBER='$PR_NUMBER'"
echo "export PR_TITLE='$PR_TITLE'"
echo "export PR_URL='$PR_URL'"
echo "export OWNER='$OWNER'"
echo "export REPO='$REPO'"
