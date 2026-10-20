#!/bin/bash
# reanchor_workspaces.sh
#
# Restores the per-monitor workspace mapping used by set_global_workspace.sh:
#
#   monitor index 0 → workspaces 1–10
#   monitor index 1 → workspaces 11–20
#   monitor index 2 → workspaces 21–30
#
# After unplugging an external display, Hyprland dumps all orphaned workspaces
# onto the remaining monitor. Running this after re-plugging snaps everything
# back into its lane.
#
# Workspaces whose target monitor index is beyond the number of currently
# connected monitors are left untouched (they'll be re-anchored next time
# that monitor is attached and this script is run).

mapfile -t MONS < <(hyprctl monitors -j | jq -r '.[].name')
NMON=${#MONS[@]}
[ "$NMON" -eq 0 ] && exit 1

# Collect regular (non-special) workspace IDs. Special workspaces have
# negative IDs under Hyprland.
mapfile -t WS < <(hyprctl workspaces -j | jq -r '.[].id' | awk '$1 >= 1' | sort -n)

for ws in "${WS[@]}"; do
    mon_idx=$(( (ws - 1) / 10 ))
    [ "$mon_idx" -ge "$NMON" ] && continue
    mon=${MONS[$mon_idx]}
    hyprctl dispatch "hl.dsp.workspace.move({ workspace = \"$ws\", monitor = \"$mon\" })" >/dev/null
done

# Re-focus workspace 1 on each monitor so the active workspace matches the
# "slot 1" convention set_global_workspace.sh uses on boot.
for i in "${!MONS[@]}"; do
    ws=$(( i * 10 + 1 ))
    hyprctl dispatch "hl.dsp.focus({ monitor = \"${MONS[$i]}\" })" >/dev/null
    hyprctl dispatch "hl.dsp.focus({ workspace = \"$ws\" })" >/dev/null
done
