#!/bin/bash

# Workspace indicator that shows active and occupied workspaces
while true; do
  # Get active workspace
  active=$(hyprctl activeworkspace -j | jq '.id')
  
  # Get all workspaces with windows
  occupied=$(hyprctl workspaces -j | jq '.[] | select(.windows > 0) | .id')
  
  # Format output
  output=""
  for i in {1..10}; do
    if [[ $i -eq $active ]]; then
      output+="[%{F#cba6f7}%{F-}]"
    elif [[ $occupied =~ $i ]]; then
      output+="[%{F#6c7086}%{F-}]"
    else
      output+="[ ]"
    fi
  done
  
  echo "Tabsheet: $output"
  sleep 1
done