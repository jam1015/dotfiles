#!/bin/sh

# Check for connected external displays excluding the default eDP
external_displays=$(xrandr | grep 'DisplayPort' | grep ' connected' | cut -d' ' -f1)

if [ -z "$external_displays" ]; then
    # No external displays found, run xrandr --auto
    xrandr --auto
else
    # Configure displays as specified
    xrandr --output eDP --mode 1280x720 --pos 1273x1080 --rotate normal \
           --output DisplayPort-0 --off \
           --output DisplayPort-1 --off \
           --output DisplayPort-2 --off \
           --output DisplayPort-3 --off \
           --output DisplayPort-4 --off \
           --output DisplayPort-5 --off \
           --output DisplayPort-6 --off \
           --output DisplayPort-7 --off \
           --output DisplayPort-8 --off \
           --output DisplayPort-9 --off \
           --output DisplayPort-10 --primary --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output DisplayPort-11 --off \
           --output DisplayPort-12 --mode 1920x1080 --pos 0x0 --rotate normal
fi
