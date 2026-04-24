#!/bin/sh
#
# set_global_workspace.sh <workspace-number>
#
# Focuses workspace N on every connected monitor simultaneously.
# Mirrors river's set_global_tags.sh behavior.
#
# Note: Unlike river tags, Hyprland workspaces are exclusive to one monitor
# at a time. This script distributes workspaces across monitors using an
# offset scheme:
#
#   Monitor 1 (primary):   workspaces 1–10  → switches to N
#   Monitor 2:             workspaces 11–20 → switches to N+10
#   Monitor 3:             workspaces 21–30 → switches to N+20
#
# If you prefer all monitors to show the exact same workspace number,
# see the SIMPLE MODE comment below.
#

N="$1"
if [ -z "$N" ]; then
    echo "Usage: $0 <workspace-number>" >&2
    exit 1
fi

# ── OFFSET MODE (default) ─────────────────────────────────────────────────────
# Each monitor gets its own workspace lane. Pressing prefix+3 gives you
# workspace 3 on mon1, 13 on mon2, 23 on mon3 — all conceptually "slot 3".

MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
IDX=0

for MON in $MONITORS; do
    OFFSET=$((IDX * 10))
    WS=$((N + OFFSET))
    hyprctl dispatch focusmonitor "$MON"
    hyprctl dispatch workspace "$WS"
    IDX=$((IDX + 1))
done

# ── SIMPLE MODE (uncomment to use) ───────────────────────────────────────────
# All monitors show workspace N. The workspace "moves" to the last monitor
# that claims it, so only one monitor will actually display it.
# Useful if you mostly work on one monitor at a time.
#
# hyprctl dispatch workspace "$N"
