#!/usr/bin/env bash
#
# For each enabled output:
#   • if height > width → main area “top”
#   • else → main area “left”
#
# Requires: wlr-randr, jq, riverctl

# Grab all enabled outputs and their current mode
json=$(wlr-randr --json)

# Iterate: for each object in the array with .enabled == true
echo "$json" | jq -r '.[] | select(.enabled) | "\(.name) \(.current_mode.width) \(.current_mode.height)"' |
while read -r name width height; do
  # Focus this output
  riverctl focus-output "$name"

  # Compare dimensions
  if (( height > width )); then
    riverctl send-layout-cmd rivertile main-location top
  else
    riverctl send-layout-cmd rivertile main-location left
  fi
done

