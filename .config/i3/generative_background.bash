#!/bin/bash

# Dependencies:
# - Python with matplotlib and numpy
# - Nitrogen (to set the wallpaper)
# - xrandr (to get monitor resolution)

# Set output directory and file
OUTPUT_DIR="$HOME/Pictures/Wallpapers"
OUTPUT_FILE="generated_wallpaper.png"
OUTPUT_PATH="$OUTPUT_DIR/$OUTPUT_FILE"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Path to the Python script
PYTHON_SCRIPT="$HOME/.config/i3/generative_art.py"

# Use xrandr to find the maximum x and y coordinates based on the current display arrangement
MAX_X=$(xrandr | grep ' connected' | awk '{print $3}' | grep -oP '\d+x\d+\+\d+\+\d+' | awk -F'[x+]' '{print $1 + $3}' | sort -nr | head -n1)
MAX_Y=$(xrandr | grep ' connected' | awk '{print $3}' | grep -oP '\d+x\d+\+\d+\+\d+' | awk -F'[x+]' '{print $2 + $4}' | sort -nr | head -n1)

# Allow the user to choose between Mandelbrot or Julia sets
# Default to 'julia' if no argument is passed
FRACTAL_TYPE=${1:-julia}

# Run the Python script to generate the wallpaper
# Pass the max x, max y, and fractal type as arguments
LOG_FILE="/tmp/generative_art.log"
python3 "$PYTHON_SCRIPT" "$OUTPUT_PATH" "$MAX_X" "$MAX_Y" "$FRACTAL_TYPE" > "$LOG_FILE" 2>&1

# Check if the Python script executed successfully
if [ $? -ne 0 ]; then
    echo "An error occurred while generating the wallpaper. Check the log file at $LOG_FILE for details."
    exit 1
fi

# Set the generated image as wallpaper using Nitrogen
nitrogen --set-zoom-fill "$OUTPUT_PATH" --save
