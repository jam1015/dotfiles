#!/bin/sh
#
# Toggle mute on the default sink, then show a dunst notification.

pactl set-sink-mute @DEFAULT_SINK@ toggle

# After toggling, get the new volume & mute status
vol=$(pactl get-sink-volume @DEFAULT_SINK@ \
      | grep -Po '[0-9]{1,3}(?=%)' \
      | head -1)
mute_status=$(pactl get-sink-mute @DEFAULT_SINK@ \
              | grep -Po '(yes|no)')

# Choose icon
if [ "$mute_status" = "yes" ] || [ "$vol" -eq 0 ]; then
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

