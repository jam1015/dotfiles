#!/bin/bash
riverctl list-inputs | grep -i touchpad | awk '{print $1}' | while read -r device; do
    [ -n "$device" ] && riverctl input "$device" natural-scroll enabled 2>/dev/null || true
done
