#!/bin/sh
# Rotate stack forward: [A,B,C,D] → [B,C,D,A]

WIN=$(hyprctl activewindow -j)
ORIG=$(echo "$WIN" | jq -r '.address')
WS_ID=$(echo "$WIN" | jq -r '.workspace.id')
COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS_ID)] | length")

[ -z "$COUNT" ] || [ "$COUNT" -le 1 ] && exit 0

# Focus A (master), then swapnext COUNT-1 times: A bubbles to end
# [A,B,C,D] → [B,A,C,D] → [B,C,A,D] → [B,C,D,A]
hyprctl dispatch layoutmsg focusmaster

i=1
while [ "$i" -le "$((COUNT - 1))" ]; do
    hyprctl dispatch layoutmsg swapnext
    i=$((i + 1))
done

hyprctl dispatch focuswindow "address:$ORIG"
