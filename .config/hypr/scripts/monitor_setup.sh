#!/bin/bash
#
# monitor_setup.sh
#
# One-shot startup helper. Delegates orientation handling to set_orientations.sh
# (which is also wired to monitor.added for hotplug). This script's remaining
# jobs are:
#   1. Reposition eDP-1 if no external DP is attached at startup.
#   2. Wait for the first window to open before touching the layout
#      (the master layout needs a window to receive layoutmsg dispatches).

LOG="/tmp/monitor_setup.log"
echo "=== monitor_setup.sh ===" > "$LOG"

# Laptop-only: reposition eDP-1
if ! hyprctl monitors | grep -q 'DP-'; then
    echo "Laptop-only mode" >> "$LOG"
    hyprctl keyword monitor "eDP-1,2880x1920@60,0x0,1.75"
fi

# Wait for socket, then for first window-open event.
SOCKET=""
while [ -z "$SOCKET" ]; do
    SOCKET=$(find "$XDG_RUNTIME_DIR/hypr" -name ".socket2.sock" | sort -t_ -k2 -n | tail -1)
    sleep 0.2
done
echo "Using socket: $SOCKET" >> "$LOG"

while read -r line; do
    if echo "$line" | grep -q "^openwindow"; then
        echo "Got openwindow → set_orientations.sh" >> "$LOG"
        ~/.config/hypr/scripts/set_orientations.sh >> "$LOG" 2>&1
        break
    fi
done < <(socat -u "UNIX-CONNECT:$SOCKET" -) &
