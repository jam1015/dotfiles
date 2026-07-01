#!/bin/bash
warp=${1:-1}
ws=$(echo "" | wofi --dmenu --prompt "Move window to workspace:" --lines 1 --width 400)
[ -z "$ws" ] && exit 0

# Treat "0" as workspace 10 (matches the keyboard "0" → slot 10 convention).
[ "$ws" = "0" ] && ws=10

# Workspace N lives on monitor index (N-1)/10 under the offset scheme used by
# set_global_workspace.sh (mon0: 1–10, mon1: 11–20, mon2: 21–30, …).
mon_idx=$(( (ws - 1) / 10 ))
mon=$(hyprctl monitors -j | jq -r ".[$mon_idx].name")

if [ "$warp" = "1" ]; then
    hyprctl dispatch movetoworkspace "$ws"
else
    # doesn't warp focus
    hyprctl dispatch movetoworkspacesilent "$ws"
fi

# Re-anchor the (now non-empty) workspace to the correct monitor in case
# it had drifted, or was just created on the wrong one.
hyprctl dispatch moveworkspacetomonitor "$ws $mon"

if [ "$warp" = "1" ]; then
    hyprctl dispatch focusmonitor "$mon"
fi
