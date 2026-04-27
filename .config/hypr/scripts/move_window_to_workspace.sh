#!/bin/bash
warp=${1:-1}
ws=$(echo "" | wofi --dmenu --prompt "Move window to workspace:" --lines 1 --width 400)
[ -z "$ws" ] && exit 0
if [ "$warp" = "1" ]; then
    hyprctl dispatch movetoworkspace "$ws"
else
    hyprctl dispatch movetoworkspacesilent "$ws"
fi
