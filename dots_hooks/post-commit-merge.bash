#!/bin/bash

eval "$(ssh-agent -s)"

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

# Define the 'dots' function to use as an alias for your specific Git setup
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

frame_echo() {
  local arg="$1"
  local line="========================================================="
  echo "$line"
  echo "$arg"
  echo "$line"
}
# Function to merge current branch into another branch recursively, then push if merge is successful

merge_to() {

  local source_branch=$1
  local target_branch=$2

  if ! branch_exists "${target_branch}"; then
    frame_echo "Branch ${target_branch} does not exist on this system."
    return 1
  fi

  frame_echo "Starting post commit/merge logic: Source: ${source_branch} | Target: ${target_branch}"

  # checking if it was called with one argument or an empty argument

  frame_echo "checking out target: ${target_branch}"
  dots checkout "${target_branch}"

  # Pull the latest changes from the origin of the target branch
  if ! dots pull origin ${target_branch}; then
    frame_echo "Pull from origin ${target_branch} failed. Resolve any issues and retry."
    return 1
  fi

  frame_echo "Pull from ${target_branch} successful. Starting merge from ${source_branch}."

  # Proceed with the merge operation
  if ! dots merge "${source_branch}"; then
    frame_echo "Merge from ${source_branch} to ${target_branch} failed. Handle merge conflicts if any."
    return 1
  fi

  frame_echo "Merge successful. Pushing to origin."
  dots push origin "${target_branch}"

  if [[ "${target_branch}" != "${source_branch}" ]]; then
    frame_echo "Recursing"
    merge_switch
  fi

  frame_echo "Checking ${source_branch} back out."
  dots checkout "${source_branch}"

}

# Merge logic
merge_switch() {
  case $(dots rev-parse --abbrev-ref HEAD) in
    "master")
      merge_to "master" "master"
      merge_to "master" "linux"
      merge_to "master" "mac"
      merge_to "master" "termux"
      ;;
    "linux")
      merge_to "linux" "linux"
      merge_to "linux" "jmtp"
      merge_to "linux" "mbp_endeavour"
      ;;
    "jmtp")
      echo "jmtp" "jmtp"
      ;;
    "mbp_endeavour")
      echo "mbp_endeavour" "mbp_endeavour"
      ;;
    "mac")
      echo "mac" "mac"
      ;;
    "termux")
      echo "termux" "termux"
      ;;
  esac
}

merge_switch

ln -sf "$work_tree/dots_hooks/post_commit.bash" "$post_commit_hook"
ln -sf "$work_tree/dots_hooks/post_merge.bash" "$post_merge_hook"
#
