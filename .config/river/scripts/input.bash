#!/bin/bash

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Find and configure touchpad with error handling
echo "Searching for touchpad devices..."

touchpad_devices=$(riverctl list-inputs 2>/dev/null | grep -i touchpad | awk '{print $1}' || true)

if [ -z "$touchpad_devices" ]; then
    echo "Warning: No touchpad devices found" >&2
    exit 0
fi

while IFS= read -r device; do
    if [ -n "$device" ]; then
        echo "Attempting to enable natural scroll for: $device"
        if riverctl input "$device" natural-scroll enabled 2>/dev/null; then
            echo "✓ Successfully configured: $device"
        else
            echo "✗ Failed to configure: $device" >&2
        fi
    fi
done <<< "$touchpad_devices"
