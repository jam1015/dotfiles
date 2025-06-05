#!/bin/sh
#
# Increase backlight by 5%, then send a dunst notification with new percentage.

brightnessctl set +5%

br=$(brightnessctl get \
     | awk '{ printf "%d", $1 * 100 / $2 }')

icon=""

dunstify \
  -t 1000 \
  -r 2593 \
  -u normal \
  "$icon $br%" \
  -h int:value:"$br" \
  -h string:hlcolor:"#7f7fff"

