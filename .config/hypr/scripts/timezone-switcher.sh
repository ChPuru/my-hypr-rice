#!/bin/bash

# Timezone switcher for Waybar
TIMEZONES=("UTC" "America/New_York" "Europe/London" "Asia/Kolkata" "Asia/Tokyo")
CURRENT_TZ=0

function get_time() {
  TZ=${TIMEZONES[$1]} date +"%H:%M"
}

function get_date() {
  TZ=${TIMEZONES[$1]} date +"%Y-%m-%d"
}

case $1 in
  "toggle")
    CURRENT_TZ=$(( (CURRENT_TZ + 1) % ${#TIMEZONES[@]} ))
    ;;
  "next")
    CURRENT_TZ=$(( (CURRENT_TZ + 1) % ${#TIMEZONES[@]} ))
    ;;
  "prev")
    CURRENT_TZ=$(( (CURRENT_TZ - 1 + ${#TIMEZONES[@]}) % ${#TIMEZONES[@]} ))
    ;;
esac

echo "{\"text\": \"$(get_time $CURRENT_TZ)\", \"tooltip\": \"${TIMEZONES[$CURRENT_TZ]}: $(get_date $CURRENT_TZ)\", \"class\": \"timezone\"}"