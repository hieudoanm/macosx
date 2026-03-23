#!/bin/bash

### GitHub ###

function ghprall() {
  gh repo list --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner' | \
xargs -n 1 -P 8 bash -c '
repo="$1"

echo "=== Processing repo: $repo ==="

gh pr list \
  --repo "$repo" \
  --state open \
  --limit 1000 \
  --json number \
  --jq ".[].number" | \
while read pr; do
  echo "[$repo] Merging PR #$pr"

  if gh pr merge "$pr" --repo "$repo" --squash; then
    echo "[$repo] ✅ Squash merged PR #$pr"
  else
    echo "[$repo] ⚠️ Direct merge failed, trying auto-merge..."

    if gh pr merge "$pr" --repo "$repo" --squash --auto; then
      echo "[$repo] ✅ Auto-merge enabled PR #$pr"
    else
      echo "[$repo] ❌ Failed PR #$pr — skipping"
    fi
  fi
done
' _
}
