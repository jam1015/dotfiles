#!/bin/bash
# samedir_kitty.sh
# Launch kitty in the same directory as the focused window's CWD.
# Hyprland exposes the active window's PID via hyprctl.

PID=$(hyprctl activewindow -j | jq -r '.pid')

if [ -n "$PID" ] && [ "$PID" != "null" ] && [ "$PID" -gt 0 ]; then
    CWD=$(readlink -f /proc/"$PID"/cwd 2>/dev/null)
fi

if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
    CWD="$HOME"
fi

exec /usr/bin/kitty --directory="$CWD"
