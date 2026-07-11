#!/bin/sh
#
# Decrease PulseAudio volume by 1%.

pactl set-sink-volume @DEFAULT_SINK@ -1%
