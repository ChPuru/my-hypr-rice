#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Use mapfile to read files safely
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) -print0 | xargs -0)

# If no wallpapers found, exit
if [ ${#wallpapers[@]} -eq 0 ]; then
  echo "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

# Function to change wallpaper
change_wallpaper() {
  local wallpaper_path="$1"
  if command -v swww >/dev/null; then
    swww img "$wallpaper_path" --transition-type grow --transition-step 5 --transition-fps 144
    # Set as current wallpaper
    ln -sf "$wallpaper_path" "$WALLPAPER_DIR/current.jpg"
  fi
}

# Change to a random wallpaper
random_wallpaper() {
  local random_index=$((RANDOM % ${#wallpapers[@]}))
  change_wallpaper "${wallpapers[$random_index]}"
}

# Change to next wallpaper in sequence
next_wallpaper() {
  if [ -f "$WALLPAPER_DIR/current.jpg" ]; then
    current_wallpaper=$(readlink -f "$WALLPAPER_DIR/current.jpg")
    for i in "${!wallpapers[@]}"; do
      if [ "${wallpapers[$i]}" = "$current_wallpaper" ]; then
        next_index=$(( (i + 1) % ${#wallpapers[@]} ))
        change_wallpaper "${wallpapers[$next_index]}"
        return
      fi
    done
  fi
  # If no current wallpaper found, use random
  random_wallpaper
}

# Handle arguments
case "$1" in
  "random")
    random_wallpaper
    ;;
  "next")
    next_wallpaper
    ;;
  *)
    echo "Usage: $0 [random|next]"
    ;;
esac