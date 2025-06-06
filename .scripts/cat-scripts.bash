#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory>" >&2
  exit 1
fi

orig="$1"
dir="$(readlink -f "$orig")"

if [ ! -d "$dir" ]; then
  echo "Error: '$orig' is not a directory" >&2
  exit 1
fi

# Loop over every regular file under $dir (recursing subdirs)
while IFS= read -r -d '' file; do
  # Determine MIME type
  mime=$(file -Lb --mime-type "$file")
  # Only allow text/* or empty files
  if [[ $mime != text/* && $mime != inode/x-empty ]]; then
    continue
  fi

  echo "=== $file ==="
  cat "$file"
  echo
done < <(find "$dir" -type f -print0)
