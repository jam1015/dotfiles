#!/bin/bash
# samedir_foot.sh
# Use whereami written by zsh's precmd hook — always reflects
# the last active shell's directory regardless of what's focused.

CWD=$(cat ~/.local/state/zsh/whereami 2>/dev/null)

if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
    CWD="$HOME"
fi

# *CLAUDE CHANGE* reverted from foot back to kitty.
#exec /usr/bin/foot --working-directory="$CWD"
exec /usr/bin/kitty --directory="$CWD"
