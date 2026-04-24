#!/bin/bash
# launch_zsh_runner.sh
# Submap exit is handled by hyprland.conf bind chain — no riverctl needed.

WHEREAMI=$(cat ~/.local/state/zsh/whereami)
pkill -f "ZSH_LAUNCHER=1" 2>/dev/null

/usr/bin/kitty --directory="$WHEREAMI" --class=Launcher -e env ZSH_LAUNCHER=1 zsh -o vi -i
