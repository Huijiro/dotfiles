#!/usr/bin/env bash
# Resolves all unresolved, non-outdated CodeRabbit review threads for the current PR.
# Exits with code 1 if there are more than 100 threads (pagination required).
# Usage: ./resolve-threads.sh

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

THREAD_IDS=$(echo "$RESPONSE" | jq -r '
  [.data.repository.pullRequest.reviewThreads.nodes[]
   | select(.isResolved == false)
   | select(.isOutdated == false)
   | select(.comments.nodes[0].author.login == "coderabbitai")
   | .id
  ] | .[]
')

if [ -z "$THREAD_IDS" ]; then
  echo "No unresolved CodeRabbit threads to resolve."
  exit 0
fi

for THREAD_ID in $THREAD_IDS; do
  echo "Resolving $THREAD_ID..."
  gh api graphql -f query='
  mutation {
    resolveReviewThread(input: { threadId: "'"$THREAD_ID"'" }) {
      thread { id isResolved }
    }
  }'
done

echo "Done."
