#!/bin/bash

battery_info=$(upower -i "$(upower -e | grep battery | head -1)")
battery=$(echo "$battery_info" | grep -E "percentage" | awk '{print $2}')
state=$(echo "$battery_info" | grep -E "state" | awk '{print $2}')

if [ "$state" = "charging" ] || [ "$state" = "fully-charged" ]; then
  echo "⚡ $battery"
else
  echo "🔋 $battery"
fi