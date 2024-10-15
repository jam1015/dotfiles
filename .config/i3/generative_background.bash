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

# Get the primary monitor's resolution
SCREEN_RESOLUTION=$(xrandr | grep '*' | head -n1 | awk '{print $1}')
SCREEN_WIDTH=$(echo $SCREEN_RESOLUTION | cut -d'x' -f1)
SCREEN_HEIGHT=$(echo $SCREEN_RESOLUTION | cut -d'x' -f2)

# Allow the user to choose between Mandelbrot or Julia sets
# Default to 'mandelbrot' if no argument is passed
FRACTAL_TYPE=${1:-julia}

# Run the Python script to generate the wallpaper
# Pass the screen width, height, and fractal type as arguments
LOG_FILE="/tmp/generative_art.log"
python3 "$PYTHON_SCRIPT" "$OUTPUT_PATH" "$SCREEN_WIDTH" "$SCREEN_HEIGHT" "$FRACTAL_TYPE" > "$LOG_FILE" 2>&1

# Check if the Python script executed successfully
if [ $? -ne 0 ]; then
    echo "An error occurred while generating the wallpaper. Check the log file at $LOG_FILE for details."
    exit 1
fi

# Set the generated image as wallpaper using Nitrogen
nitrogen --set-zoom-fill "$OUTPUT_PATH" --save
