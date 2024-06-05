#!/bin/bash
# post-commit hook

# Find the top-level directory of the repository
GIT_DIR=$(git rev-parse --show-toplevel)

# Run post-commit actions for all normal commits
echo "Running post-commit actions for a normal commit."
"$GIT_DIR/.dots_hooks/post-commit-merge.bash"
