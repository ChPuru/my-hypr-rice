#!/bin/bash
# Try different temperature sources
temp=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n1)
if [ -n "$temp" ]; then
  echo "$((temp/1000))°C"
else
  echo "N/A"
fi