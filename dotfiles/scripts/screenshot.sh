#!/usr/bin/env bash

# This script handles taking screenshots with grim, slurp, and swappy.

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILENAME="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

# Function to send a notification
send_notification() {
    makoctl notify -a "screenshot_tool" -i "camera-photo" "Screenshot Taken" "Saved to $FILENAME"
}

# Main logic
case $1 in
    full)
        grim "$FILENAME"
        send_notification
        ;;
    region)
        grim -g "$(slurp)" "$FILENAME"
        send_notification
        ;;
    edit)
        grim -g "$(slurp)" - | swappy -f -
        # Swappy handles its own saving, so no notification here.
        ;;
    *)
        echo "Usage: $0 {full|region|edit}"
        exit 1
        ;;
esac