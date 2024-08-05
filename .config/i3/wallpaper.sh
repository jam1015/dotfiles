#!/bin/bash

# Path to your wallpaper image
WALLPAPER_PATH="$HOME/.config/i3/wallpaper.sh"

# Check if the image exists
if [ -f "$WALLPAPER_PATH" ]; then
  # Set the wallpaper using feh
  feh --bg-scale "$WALLPAPER_PATH"
fi
