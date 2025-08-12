#!/usr/bin/env bash

# This script uses hyprpicker to select a color and notifies the user.

# Run hyprpicker and auto-copy the color to the clipboard
hyprpicker -a

# Get the copied hex value from the clipboard
color_hex=$(wl-paste)

# Send a notification with the color value
makoctl notify -a "color_picker" -i "color-select" "Color Picked" "Copied <b>${color_hex}</b> to clipboard."