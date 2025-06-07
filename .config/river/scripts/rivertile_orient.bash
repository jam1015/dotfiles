#!/usr/bin/env bash
#
# For each enabled output with a valid “current” mode:
#   • Normalize its .transform (numeric or string) → integer 0|90|180|270
#   • Swap width/height if angle is 90 or 270
#   • If effective height > effective width → send "main-location top"
#   • Else → send "main-location left"
#
# Requires: wlr-randr, jq, riverctl

json=$(wlr-randr --json)

echo "$json" \
  | jq -r '
      .[]
      | select(.enabled == true)
      | . as $out
      | ($out.modes[]? | select(.current == true)) as $m
      | # If transform is null, default to 0. Convert anything else to its JSON representation.
        "\($out.name) \($m.width) \($m.height) \($out.transform // 0)"
    ' \
  | while read -r name width height transform_raw; do

    # 1) Skip if width/height aren’t numeric
    if ! printf "%d" "$width" >/dev/null 2>&1 || ! printf "%d" "$height" >/dev/null 2>&1; then
      continue
    fi

    # 2) Normalize transform_raw → integer “transform”
    case "$transform_raw" in
      ''            ) transform=0   ;;  # shouldn't happen, but just in case
      normal        ) transform=0   ;;
      rotated-90    ) transform=90  ;;
      rotated-180   ) transform=180 ;;
      rotated-270   ) transform=270 ;;
      *[!0-9]*     ) transform=0   ;;  # any other non‐numeric => assume 0
      *) transform=$transform_raw ;;  # pure digits (e.g. “90” or “180”)
    esac

    # 3) Focus that output so send-layout-cmd targets its rivertile generator
    riverctl focus-output "$name"

    # 4) Compute “effective” width/height
    if [ "$transform" -eq 90 ] || [ "$transform" -eq 270 ]; then
      eff_w=$height
      eff_h=$width
    else
      eff_w=$width
      eff_h=$height
    fi

    # 5) Compare and send the properly quoted command
    if [ "$eff_h" -gt "$eff_w" ]; then
      riverctl send-layout-cmd rivertile "main-location top"
    else
      riverctl send-layout-cmd rivertile "main-location left"
    fi
  done
