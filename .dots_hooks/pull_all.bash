#!/bin/bash

set -e  # Exit on any command failure

# Save the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Function to pull from origin
pull_branch() {
  local branch="$1"
  echo "Pulling updates for branch: $branch"
  git checkout "$branch"
  if git pull origin "$branch"; then
    echo "Updates pulled successfully for branch: $branch"
  else
    echo "Conflict detected in branch: $branch. Please resolve manually."
    return 1  # Return an error code to indicate a conflict
  fi
}

# Iterate over all local branches and pull
git for-each-ref --format='%(refname:short)' refs/heads/ | while read -r branch; do
  if ! pull_branch "$branch"; then
    echo "Stopping the script due to a conflict."
    exit 1  # Exit the script entirely if a conflict occurs
  fi
done

# Checkout the original branch
git checkout "$current_branch"
echo "Returned to the original branch: $current_branch"
