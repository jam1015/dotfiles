#!/bin/sh
#
# monitor_setup.sh
# Mirrors the wlr-randr conditional logic from the river init.
# Run via exec-once — uses hyprctl keyword to override monitor positions
# depending on whether DP outputs are connected.
#
# Hyprland static monitor= lines handle the case when DP is present.
# This script fixes eDP-1 position for laptop-only mode.

sleep 0.5  # give compositor time to enumerate outputs

if hyprctl monitors | grep -q 'DP-'; then
    # Multi-monitor: positions already set correctly by hyprland.conf
    # DP-11: 0x0, rotated 90  (1080px wide after rotation)
    # DP-13: 1080x0, normal
    # eDP-1: 1080x1080, scaled 1.75
    echo "Multi-monitor setup detected, using static config."

    # Set master layout orientation per monitor:
    # DP-11 is rotated 90° → effective portrait → top layout
    hyprctl -i 0 keyword monitor "DP-11,1920x1080@60,0x0,1,transform,1"
    hyprctl dispatch focusmonitor DP-11
    hyprctl dispatch layoutmsg orientationtop

    # DP-13 and eDP-1 are landscape → left layout
    hyprctl dispatch focusmonitor DP-13
    hyprctl dispatch layoutmsg orientationleft

    hyprctl dispatch focusmonitor eDP-1
    hyprctl dispatch layoutmsg orientationleft
else
    # Laptop-only: move eDP-1 to 0x0
    echo "Laptop-only mode."
    hyprctl keyword monitor "eDP-1,2880x1920@60,0x0,1.75"
    hyprctl dispatch layoutmsg orientationleft
fi
