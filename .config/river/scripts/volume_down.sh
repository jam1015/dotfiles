#!/bin/sh
#
# Decrease PulseAudio volume by 1%, show a dunst notification with the new level.

pactl set-sink-volume @DEFAULT_SINK@ -1%

vol=$(pactl get-sink-volume @DEFAULT_SINK@ \
      | grep -Po '[0-9]{1,3}(?=%)' \
      | head -1)

if [ "$vol" -eq 0 ] || [ "$(pactl get-sink-mute @DEFAULT_SINK@ \
     | grep -Po '(?<=Mute: )(yes|no)')" = "yes" ]; then
  icon=""
elif [ "$vol" -lt 50 ]; then
  icon=""
else
  icon=""
fi

dunstify \
  -i audio-volume-muted-blocking \
  -t 1000 \
  -r 2593 \
  -u normal \
  "$icon $vol%" \
  -h int:value:"$vol" \
  -h string:hlcolor:"#7f7fff"

