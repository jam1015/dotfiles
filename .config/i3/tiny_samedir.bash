#!/bin/bash

# Get the username of the person running the script
USER=$(whoami)

# Construct the filepath with the user-specific filename
WHEREAMI=$(cat /tmp/whereami_$USER)

# Start kitty terminal emulator with the specific directory
/usr/bin/kitty --directory="$WHEREAMI"
