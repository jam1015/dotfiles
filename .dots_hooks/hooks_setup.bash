#!/bin/bash

# Define the directory where the bare repository is located
GIT_DIR="$HOME/dotfiles.git"

# Define the working tree directory
WORK_TREE="$HOME"

# Ensure the hooks directory exists
mkdir -p "$GIT_DIR/hooks"

# Create symlinks for hooks
ln -sf "$WORK_TREE/.dots_hooks/post_commit.bash" "$GIT_DIR/hooks/post-commit"
ln -sf "$WORK_TREE/.dots_hooks/post_merge.bash" "$GIT_DIR/hooks/post-merge"
#
