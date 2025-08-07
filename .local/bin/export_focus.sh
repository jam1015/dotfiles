#!/bin/sh
[ -n "$WAYBAR_OUTPUT_NAME" ] &&
  printf '%s\n' "$WAYBAR_OUTPUT_NAME" \
    > "$XDG_RUNTIME_DIR/river_focused_output"   # spec-compliant temp dir
printf '{"text":""}\n'                          # keep the module invisible
