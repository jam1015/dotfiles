#!/bin/bash

# Construct the filepath with the user-specific filename
WHEREAMI=$(cat ~/.local/state/zsh/whereami)

# Start kitty terminal emulator with the specific directory
/usr/bin/neovide -- -i NONE
#-c "luafile ~/.config/i3/samedir.lua"
