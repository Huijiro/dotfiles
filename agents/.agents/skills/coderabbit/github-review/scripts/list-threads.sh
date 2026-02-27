#!/usr/bin/env bash
# Fetches and lists all unresolved, non-outdated CodeRabbit review threads for the current PR.
# Exits with code 1 if there are more than 100 threads (pagination required).
# Usage: ./list-threads.sh

set -euo pipefail

eval "$(./get-pr-info.sh)"

RESPONSE=$(gh api graphql -f query='
{
  repository(owner: "'"$OWNER"'", name: "'"$REPO"'") {
    pullRequest(number: '"$PR_NUMBER"') {
      reviewThreads(first: 100) {
        totalCount
        nodes {
          id
          isResolved
          isOutdated
          comments(first: 1) {
            nodes {
              author { login }
              path
              line
              body
            }
          }
        }
      }
    }
  }
}')

TOTAL=$(echo "$RESPONSE" | jq -r '.data.repository.pullRequest.reviewThreads.totalCount')
if [ "$TOTAL" -gt 100 ]; then
  echo "WARNING: This PR has $TOTAL review threads but only the first 100 were fetched. Aborting to avoid missing threads." >&2
  exit 1
fi

echo "$RESPONSE" | jq -r '
  [.data.repository.pullRequest.reviewThreads.nodes[]
   | select(.isResolved == false)
   | select(.isOutdated == false)
   | select(.comments.nodes[0].author.login == "coderabbitai")
  ] | "Unresolved CodeRabbit conversations: \(length)\n",
    (to_entries[]
     | "\(.key + 1). [\(.value.id)] \(.value.comments.nodes[0].path):\(.value.comments.nodes[0].line // "N/A")\n   \(.value.comments.nodes[0].body | split("\n") | map(select(length > 0)) | join("\n   "))\n"
    )
'
