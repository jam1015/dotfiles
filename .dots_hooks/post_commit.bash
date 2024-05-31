#!/bin/bash
# post-commit hook

# Run post-commit actions for all normal commits
echo "Running post-commit actions for a normal commit."
"$HOME/.dots_hooks/post-commit-merge.bash"
#
