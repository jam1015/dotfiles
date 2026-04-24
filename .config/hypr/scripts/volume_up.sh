#!/bin/sh
#
# Increase PulseAudio volume by 1%, show a dunst notification with the new level.

# Unmute if muted, then increase volume
pactl set-sink-mute @DEFAULT_SINK@ 0
pactl set-sink-volume @DEFAULT_SINK@ +1%

# Fetch the current volume percentage (first value)
vol=$(pactl get-sink-volume @DEFAULT_SINK@ \
      | grep -Po '[0-9]{1,3}(?=%)' \
      | head -1)

# Determine icon
if [ "$vol" -eq 0 ] || [ "$(pactl get-sink-mute @DEFAULT_SINK@ \
     | grep -Po '(?<=Mute: )(yes|no)')" = "yes" ]; then
  icon=""
elif [ "$vol" -lt 50 ]; then
  icon=""
else
  icon=""
fi

# Send notification
dunstify \
  -i audio-volume-muted-blocking \
  -t 1000 \
  -r 2593 \
  -u normal \
  "$icon $vol%" \
  -h int:value:"$vol" \
  -h string:hlcolor:"#7f7fff"
