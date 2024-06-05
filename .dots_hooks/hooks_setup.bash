#!/bin/bash

# Find the .git directory
GIT_DIR=$(git rev-parse --show-toplevel)

# Ensure the hooks directory exists
mkdir -p "$GIT_DIR/.git/hooks"

# Create symlinks for hooks
ln -sf "$GIT_DIR/.dots_hooks/post_commit.bash" "$GIT_DIR/.git/hooks/post-commit"
ln -sf "$GIT_DIR/.dots_hooks/post_merge.bash" "$GIT_DIR/.git/hooks/post-merge"
