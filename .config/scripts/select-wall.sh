#!/bin/bash

# Set config paths
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="$XDG_CONFIG_HOME/scripts"
ROFI_CONFIG="$XDG_CONFIG_HOME/rofi/wallpaper-select.rasi"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CHOOSER="Wallpaper Selector"

# --- VALIDATION ---
# (Your validation checks are good, no changes needed here)
if [ ! -d "$WALLPAPER_DIR" ]; then exit 1; fi
if [ ! -f "$ROFI_CONFIG" ]; then exit 1; fi
if [ ! -x "$CONFIG_DIR/switch-wall.sh" ]; then exit 1; fi

# --- SCRIPT LOGIC ---

# This function finds all images and formats them for Rofi's dmenu mode
generate_menu_entries() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | shuf |
    while read -r file; do
        filename=$(basename "$file")
        # Keep the full path as the main entry, and add the icon and info metadata
        echo -en "$file\x00icon\x1f$file\x1finfo\x1f$filename\n"
    done
}

# 1. Generate the list and pipe it to Rofi.
# 2. Rofi returns the selected full path to the 'imgpath' variable.
imgpath=$(generate_menu_entries | rofi -dmenu -theme "$ROFI_CONFIG" -show-icons)

# Check if a wallpaper was selected
if [ -z "$imgpath" ]; then
    notify-send -a "$CHOOSER" "Info" "No wallpaper selected"
    exit 0
fi

# Apply the selected wallpaper using the smart script
"$CONFIG_DIR/switch-wall.sh" "$imgpath"