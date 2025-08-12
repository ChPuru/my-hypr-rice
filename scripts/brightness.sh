#!/usr/bin/env bash

# This script controls screen brightness and sends a notification.
# Uses brightnessctl.

# Function to send a notification
send_notification() {
    local current
    current=$(brightnessctl g)
    local max
    max=$(brightnessctl m)
    local percent=$((current * 100 / max))
    local icon="display-brightness"
    
    # Use a replace ID to update the same notification
    makoctl notify -a "brightness_control" -i "$icon" -r 9992 "Brightness: ${percent}%"
}

# Main logic
case $1 in
    up)
        brightnessctl set 5%+
        send_notification
        ;;
    down)
        brightnessctl set 5%-
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac