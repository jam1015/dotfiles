#!/bin/bash

if [[ -n "$DOTSREMOTEACTIONS" ]]; then
  eval "$(ssh-agent -s)"
fi

original_display=$DISPLAY

# Add your SSH key and set a timeout (in seconds)
unset DISPLAY
ssh-add -t 3600 ~/.ssh/id_ed25519

git_dir="$HOME/dotfiles.git/hooks"
work_tree="$HOME"
post_commit_hook="$git_dir/post-commit"
post_merge_hook="$git_dir/post-merge"

if [[ -L "$post_commit_hook" || -L "$post_merge_hook" ]]; then
  # Remove symlinks if they exist
  [[ -L "$post_commit_hook" ]] && rm -f "$post_commit_hook"
  [[ -L "$post_merge_hook" ]] && rm -f "$post_merge_hook"
  echo "Hooks removed."
fi

dots() {
  /usr/bin/git --git-dir=$HOME/dotfiles.git --work-tree=$HOME "$@"
}

# Function to check if a branch exists locally
branch_exists() {
  if dots show-ref --verify --quiet "refs/heads/$1"; then
    return 0 # branch exists
  else
    return 1 # branch does not exist
  fi
}

# Global variable to track recursion depth
recursion_depth=0

echo_indent() {
   printf "%*s%s\n" "$1" "" "$2"
}

frame_echo() {
  local arg="$1"
  local line="========================================================="
  local indent_level=$((recursion_depth * 2)) # Each level adds 2 spaces
  echo_indent "$indent_level" "$line"
  echo_indent "$indent_level" "$arg"
  echo_indent "$indent_level" "$line"
}

rebase_or_merge() {
  local source_branch=$1
  local target_branch=$2

  # Skip if source and target branches are the same
  if [[ "$source_branch" == "$target_branch" ]]; then
    frame_echo "Source and target branches are the same: $source_branch. Skipping rebase/merge."
    return 0
  fi

  if [[ -n "$DOTSTRYREBASE" ]]; then
    # Attempt to rebase first
    if ! dots rebase "${source_branch}"; then
      frame_echo "Rebase from ${source_branch} to ${target_branch} failed. Aborting. Falling back to merge."
      # Abort the rebase in case of conflicts
      dots rebase --abort

      # Attempt to merge if rebase fails
      if ! dots merge "${source_branch}"; then
        frame_echo "Merge from ${source_branch} to ${target_branch} also failed. Handle merge conflicts if any."
      else
        frame_echo "Merge successful after rebase failure."
      fi
    else
      rebased="true"
      frame_echo "Rebase successful."
    fi
  else
    # If DOTSTRYREBASE is not set, proceed with merge
    frame_echo "DOTSTRYREBASE is not set. Proceeding with merge."
    if ! dots merge "${source_branch}"; then
      frame_echo "Merge from ${source_branch} to ${target_branch} failed. Handle merge conflicts if any."
    else
      frame_echo "Merge successful."
    fi
  fi

  if [[ -n "$rebased" ]] && [[ -n "$DOTSREMOTEACTIONS" ]]; then
    if ! dots pull origin "${target_branch}"; then
      frame_echo "Pull from origin ${target_branch} failed. Resolve any issues and retry."
      return 1
    else
      frame_echo "Second pull of  ${target_branch}  after rebase successful."
    fi
  fi

  return 0
}

merge_to() {

  local source_branch=$1
  local target_branch=$2

  if ! branch_exists "${target_branch}"; then
    frame_echo "Branch ${target_branch} does not exist on this system."
    ((recursion_depth--))
    return 1
  fi

  frame_echo "Starting post commit/merge logic: Source: ${source_branch} | Target: ${target_branch}"

  # Switch to the target branch only if it's not the current branch
  if [[ "$(dots rev-parse --abbrev-ref HEAD)" != "${target_branch}" ]]; then
    frame_echo "Checking out target: ${target_branch}"
    dots checkout "${target_branch}"
  fi

  if [[ -n "$DOTSREMOTEACTIONS" ]]; then
    # Pull the latest changes from the origin of the target branch
    if ! dots pull origin "${target_branch}"; then
      frame_echo "Pull from origin ${target_branch} failed. Resolve any issues and retry."
      ((recursion_depth--))
      return 1
    fi
    frame_echo "Pull from ${target_branch} successful. Starting rebase or merge from ${source_branch}."
  else
    frame_echo "DOTSREMOTEACTIONS is not set. Skipping pull."
  fi

  # Attempt to rebase, and fall back to merge if rebase fails
  if ! rebase_or_merge "${source_branch}" "${target_branch}"; then
    frame_echo "merge or rebase failed"
    return 1
  fi

  if [[ -n "$DOTSREMOTEACTIONS" ]]; then
    frame_echo "Pushing to origin."
    dots push origin "${target_branch}"
  else
    frame_echo "DOTSREMOTEACTIONS is not set. Skipping push."
  fi

  # Skip checkout if source and target branches are the same
  if [[ "$(dots rev-parse --abbrev-ref HEAD)" != "${source_branch}" ]]; then
    frame_echo "Checking ${source_branch} back out."
    dots checkout "${source_branch}"
  fi

  frame_echo "Completed post commit/merge logic: Source: ${source_branch} | Target: ${target_branch}"

}

# This function now just prepares the queue and processes it
merge_switch() {
  # Declare an associative array to map branches to their respective targets
  declare -A branch_map
  branch_map["master"]="linux mac termux"
  branch_map["linux"]="jmtp mbp_endeavour"
  branch_map["mac"]=""
  branch_map["termux"]=""
  branch_map["jmtp"]=""
  branch_map["mbp_endeavour"]=""

  # Start with the current branch
  local current_branch=$(dots rev-parse --abbrev-ref HEAD)
  local original_branch=$current_branch
  local branches_to_process=($current_branch)
  local next_level_branches=()

  while [ ${#branches_to_process[@]} -ne 0 ]; do
    for branch in "${branches_to_process[@]}"; do
      # Extract targets for the current branch
      local targets=(${branch_map[$branch]})
      for target in "${targets[@]}"; do
        merge_to "$branch" "$target"
        next_level_branches+=("$target")
      done
    done
    # Prepare the next level of branches
    branches_to_process=("${next_level_branches[@]}")
    next_level_branches=()
  done

  dots checkout "$original_branch"
}

merge_switch

ln -sf "$work_tree/.dots_hooks/post_commit.bash" "$post_commit_hook"
ln -sf "$work_tree/.dots_hooks/post_merge.bash" "$post_merge_hook"


export DISPLAY=$original_display
