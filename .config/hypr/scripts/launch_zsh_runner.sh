#!/bin/bash
# launch_zsh_runner.sh
# Submap exit is handled by hyprland.conf bind chain — no riverctl needed.

WHEREAMI=$(cat ~/.local/state/zsh/whereami)
pkill -f "ZSH_LAUNCHER=1" 2>/dev/null

# *CLAUDE CHANGE* reverted foot → kitty (foot's --working-directory/--app-id → kitty's --directory/--class).
#/usr/bin/foot --working-directory="$WHEREAMI" --app-id=Launcher env ZSH_LAUNCHER=1 zsh -o vi -i
/usr/bin/kitty --directory="$WHEREAMI" --class=Launcher env ZSH_LAUNCHER=1 zsh -o vi -i
