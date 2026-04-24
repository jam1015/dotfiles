#!/bin/bash
#
# monitor_setup.sh
# Waits for the first window open event, then sets per-monitor orientation.
# This ensures the layout manager has a window to work with before dispatching.

LOG="/tmp/monitor_setup.log"
echo "=== monitor_setup.sh ===" > "$LOG"

# Laptop-only: reposition eDP-1
if ! hyprctl monitors | grep -q 'DP-'; then
    echo "Laptop-only mode" >> "$LOG"
    hyprctl keyword monitor "eDP-1,2880x1920@60,0x0,1.75"
fi

set_orientations() {
    hyprctl monitors -j | jq -c '.[]' | while read -r mon; do
        name=$(echo "$mon" | jq -r '.name')
        width=$(echo "$mon" | jq -r '.width')
        height=$(echo "$mon" | jq -r '.height')
        transform=$(echo "$mon" | jq -r '.transform')

        if [ "$transform" -eq 1 ] || [ "$transform" -eq 3 ]; then
            eff_w=$height
            eff_h=$width
        else
            eff_w=$width
            eff_h=$height
        fi

        if [ "$eff_h" -gt "$eff_w" ]; then
            orientation="orientationtop"
        else
            orientation="orientationleft"
        fi

        echo "$name: ${eff_w}x${eff_h} → $orientation" >> "$LOG"
        hyprctl dispatch focusmonitor "$name"
        hyprctl dispatch layoutmsg "$orientation"
    done
    echo "Orientations set." >> "$LOG"
}

# Find the socket for the current instance
# Wait for socket to appear
SOCKET=""
while [ -z "$SOCKET" ]; do
    SOCKET=$(find "$XDG_RUNTIME_DIR/hypr" -name ".socket2.sock" | sort -t_ -k2 -n | tail -1)
    sleep 0.2
done
echo "Using socket: $SOCKET" >> "$LOG"
echo "Waiting for first window..." >> "$LOG"

# Use process substitution so set_orientations is visible inside the loop
while read -r line; do
    if echo "$line" | grep -q "^openwindow"; then
        echo "Got openwindow event: $line" >> "$LOG"
        set_orientations
        break
    fi
done < <(socat -u "UNIX-CONNECT:$SOCKET" -) &
