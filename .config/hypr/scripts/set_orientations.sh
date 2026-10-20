#!/bin/bash
# set_orientations.sh
#
# For each connected monitor, pick the master-layout orientation based on
# effective (post-transform) aspect ratio:
#   portrait  → orientationtop
#   landscape → orientationleft
#
# Called at startup by monitor_setup.sh and automatically on monitor hotplug
# via a hook in hyprland.lua.

hyprctl monitors -j | jq -c '.[]' | while read -r mon; do
    name=$(echo "$mon" | jq -r '.name')
    w=$(echo "$mon" | jq -r '.width')
    h=$(echo "$mon" | jq -r '.height')
    t=$(echo "$mon" | jq -r '.transform')
    if [ "$t" -eq 1 ] || [ "$t" -eq 3 ]; then
        eff_w=$h; eff_h=$w
    else
        eff_w=$w; eff_h=$h
    fi
    if [ "$eff_h" -gt "$eff_w" ]; then
        orientation="orientationtop"
    else
        orientation="orientationleft"
    fi
    hyprctl dispatch "hl.dsp.focus({ monitor = \"$name\" })" >/dev/null
    hyprctl dispatch "hl.dsp.layout(\"$orientation\")" >/dev/null
done
