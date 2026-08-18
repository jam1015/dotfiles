#!/bin/sh
# Rotate stack forward: [A,B,C,D] → [D,A,B,C]

WIN=$(hyprctl activewindow -j)
ORIG=$(echo "$WIN" | jq -r '.address')
WS_ID=$(echo "$WIN" | jq -r '.workspace.id')
COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS_ID)] | length")

[ -z "$COUNT" ] || [ "$COUNT" -le 1 ] && exit 0

if [ "$COUNT" -eq 2 ]; then
    hyprctl dispatch 'hl.dsp.layout("swapwithmaster")'
    hyprctl dispatch "hl.dsp.focus({ window = \"address:$ORIG\" })"
    exit 0
fi

# Lift last slave (D) into master → [D, B, C, A]  (A lands at D's old position)
hyprctl dispatch 'hl.dsp.layout("focusmaster")'
hyprctl dispatch 'hl.dsp.layout("cycleprev")'       # focus D (last slave)
hyprctl dispatch 'hl.dsp.layout("swapwithmaster")'  # [D, B, C, A]

# A is now at the end; bubble it forward to first-slave position
hyprctl dispatch 'hl.dsp.layout("cycleprev")'       # focus A (last slave, wrap from master)
i=1
while [ "$i" -le "$((COUNT - 2))" ]; do
    hyprctl dispatch 'hl.dsp.layout("swapprev")'
    i=$((i + 1))
done

hyprctl dispatch "hl.dsp.focus({ window = \"address:$ORIG\" })"


