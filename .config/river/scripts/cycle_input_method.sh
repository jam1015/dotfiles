#!/bin/bash
# ~/.config/river/scripts/cycle_input_method.sh

# List your input methods in the order you want to cycle
METHODS=("keyboard-us" "pinyin")

# Get current input method
CURRENT=$(fcitx5-remote -n 2>/dev/null)

# Find current index
for i in "${!METHODS[@]}"; do
    if [[ "${METHODS[$i]}" == "$CURRENT" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Calculate next index (wrap around)
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#METHODS[@]} ))

# Activate the next input method
fcitx5-remote -s "${METHODS[$NEXT_INDEX]}"

# Tell waybar to update immediately
pkill -RTMIN+8 waybar
