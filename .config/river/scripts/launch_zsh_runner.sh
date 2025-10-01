#!/bin/bash
riverctl enter-mode normal

WHEREAMI=$(cat ~/.local/state/zsh/whereami)
# Kill any existing launcher instances
pkill -f "ZSH_LAUNCHER=1" 2>/dev/null

# Launch terminal with the launcher environment variable
# Using kitty since you have tiny_samedir_kitty in your config
/usr/bin/kitty  --directory="$WHEREAMI" --class=Launcher -e env ZSH_LAUNCHER=1 zsh -o vi -i
