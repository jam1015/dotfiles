#!/bin/sh
#
# Increase PulseAudio volume by 1%.

pactl set-sink-mute @DEFAULT_SINK@ 0
pactl set-sink-volume @DEFAULT_SINK@ +1%
