#!/usr/bin/env bash

# This script controls volume and sends a notification.
# Uses pamixer.

# Function to send a notification
send_notification() {
    local volume
    volume=$(pamixer --get-volume)
    local mute
    mute=$(pamixer --get-mute)
    local icon=""

    if [[ "$mute" == "true" ]]; then
        icon="audio-volume-muted"
        text="Volume Muted"
    else
        if (( volume >= 70 )); then
            icon="audio-volume-high"
        elif (( volume >= 30 )); then
            icon="audio-volume-medium"
        else
            icon="audio-volume-low"
        fi
        text="Volume: ${volume}%"
    fi
    
    # Use a replace ID to update the same notification
    makoctl notify -a "volume_control" -i "$icon" -r 9991 "$text"
}

# Main logic
case $1 in
    up)
        pamixer -i 5
        send_notification
        ;;
    down)
        pamixer -d 5
        send_notification
        ;;
    mute)
        pamixer -t
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac