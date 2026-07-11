#!/bin/sh
#
# Toggle mute on the default sink.

pactl set-sink-mute @DEFAULT_SINK@ toggle
