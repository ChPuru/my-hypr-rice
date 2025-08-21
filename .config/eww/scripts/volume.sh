#!/bin/bash
volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
  echo "🔇 Muted"
else
  if [ "$volume" -eq 0 ]; then
    echo "🔈 $volume%"
  elif [ "$volume" -le 50 ]; then
    echo "🔉 $volume%"
  else
    echo "🔊 $volume%"
  fi
fi