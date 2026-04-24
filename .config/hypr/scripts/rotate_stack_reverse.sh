#!/bin/sh
# Rotate stack backward: [A,B,C,D] → [D,A,B,C]

WIN=$(hyprctl activewindow -j)
ORIG=$(echo "$WIN" | jq -r '.address')
WS_ID=$(echo "$WIN" | jq -r '.workspace.id')
COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS_ID)] | length")

[ -z "$COUNT" ] || [ "$COUNT" -le 1 ] && exit 0

if [ "$COUNT" -eq 2 ]; then
    hyprctl dispatch layoutmsg swapwithmaster
    hyprctl dispatch focuswindow "address:$ORIG"
    exit 0
fi

# Lift last slave (D) into master → [D, B, C, A]  (A lands at D's old position)
hyprctl dispatch layoutmsg focusmaster
hyprctl dispatch layoutmsg cycleprev       # focus D (last slave)
hyprctl dispatch layoutmsg swapwithmaster  # [D, B, C, A]

# A is now at the end; bubble it forward to first-slave position
hyprctl dispatch layoutmsg cycleprev       # focus A (last slave, wrap from master)
i=1
while [ "$i" -le "$((COUNT - 2))" ]; do
    hyprctl dispatch layoutmsg swapprev
    i=$((i + 1))
done

hyprctl dispatch focuswindow "address:$ORIG"
