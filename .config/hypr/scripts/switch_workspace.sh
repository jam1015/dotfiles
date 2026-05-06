#!/bin/bash
ws=$(echo "" | wofi --dmenu --prompt "Workspace:" --lines 1 --width 300)
[ -z "$ws" ] && exit 0
hyprctl dispatch workspace "$ws"
