#!/bin/bash
# samedir_kitty.sh
# Use whereami written by zsh's precmd hook — always reflects
# the last active shell's directory regardless of what's focused.

CWD=$(cat ~/.local/state/zsh/whereami 2>/dev/null)

if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
    CWD="$HOME"
fi

exec /usr/bin/kitty --directory="$CWD"
