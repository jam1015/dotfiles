#!/bin/bash
# focus_workspace_here.sh
#
# wofi prompt → select a workspace number → move that workspace to the
# CURRENTLY FOCUSED output and focus it there.
#
# Analog of move_window_to_workspace.sh, but it drags the workspace itself
# (not just a window) onto the active monitor. Useful after unplugging an
# external display, when ws 11–30 all pile onto eDP-1 and you want to pull
# one back to whatever monitor you're on.

ws=$(echo "" | wofi --dmenu --prompt "Workspace to this output:" --lines 1 --width 400 \
  --conf  ~/.config/wofi/workspace.conf \
  --style ~/.config/wofi/workspace.css)
[ -z "$ws" ] && exit 0

# "0" → 10 (keyboard "0" means slot 10, matches other scripts).
[ "$ws" = "0" ] && ws=10

mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
[ -z "$mon" ] && exit 1

hyprctl dispatch "hl.dsp.focus({ monitor = \"$mon\" })"
hyprctl dispatch "hl.dsp.focus({ workspace = \"$ws\" })"
hyprctl dispatch "hl.dsp.workspace.move({ workspace = \"$ws\", monitor = \"$mon\" })"
hyprctl dispatch "hl.dsp.focus({ workspace = \"$ws\" })"
