#!/bin/bash
ws=$(echo "" | wofi --dmenu --prompt "Workspace:" --lines 1 --width 300 \
  --conf  ~/.config/wofi/workspace.conf \
  --style ~/.config/wofi/workspace.css)
[ -z "$ws" ] && exit 0
hyprctl dispatch "hl.dsp.focus({ workspace = \"$ws\" })"
