#!/bin/bash
# post-merge hook

# Find the top-level directory of the repository
GIT_DIR=$(git rev-parse --show-toplevel)

# Check if the merge did NOT result in a commit
if [ -f "$GIT_DIR/.git/MERGE_HEAD" ] && [ "$(git rev-parse HEAD)" == "$(git rev-parse ORIG_HEAD)" ]; then
    echo "Fast-forward merge detected, running post-commit actions."
    "$GIT_DIR/.dots_hooks/post-commit-merge.bash"
else
    echo "Non-fast-forward merge completed; no additional actions required."
fi

