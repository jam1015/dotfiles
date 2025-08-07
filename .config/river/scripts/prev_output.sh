#!/bin/sh
out=$(<"$XDG_RUNTIME_DIR/river_focused_output" 2>/dev/null)

riverctl close
sleep 0.04                     # let unmap finish

[ -n "$out" ] && riverctl focus-output "$out"
#riverctl focus-view -skip-floating next   # River ≥ 0.3 

