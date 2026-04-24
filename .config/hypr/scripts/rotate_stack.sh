#!/bin/sh
#
# rotate_stack.sh
# Rotate the master layout stack forward by one position:
#   [A, B, C, D]  →  [B, C, D, A]
#
# Strategy:
#   1. Move focus to B (cyclenext)
#   2. swapwithmaster  →  [B, A, C, D], focus on B
#   3. cyclenext       →  focus on A (slot 2)
#   4. swapnext (COUNT-2) times  →  A moves to end
#   5. focusmaster     →  land back on B
#

WS_ID=$(hyprctl activewindow -j | jq '.workspace.id')
COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS_ID)] | length")

# Nothing to rotate with 0 or 1 windows
if [ -z "$COUNT" ] || [ "$COUNT" -le 1 ]; then
    exit 0
fi

# Only one window besides master — simple swap suffices
if [ "$COUNT" -eq 2 ]; then
    hyprctl dispatch layoutmsg swapwithmaster
    exit 0
fi

# Step 1: focus next (B)
hyprctl dispatch layoutmsg cyclenext

# Step 2: swap B into master slot → [B, A, C, D]
hyprctl dispatch layoutmsg swapwithmaster

# Step 3: focus A (now at slot 2)
hyprctl dispatch layoutmsg cyclenext

# Step 4: push A to end of slave stack
i=1
while [ "$i" -le "$((COUNT - 2))" ]; do
    hyprctl dispatch layoutmsg swapnext
    i=$((i + 1))
done

# Step 5: refocus master (B)
hyprctl dispatch layoutmsg focusmaster
