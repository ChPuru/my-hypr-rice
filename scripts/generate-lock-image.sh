#!/usr/bin/env bash

# --- Script to generate a rounded profile picture for the lock screen ---

set -e

# --- Config ---
INPUT_IMAGE="$1"
OUTPUT_DIR="$HOME/.config/hypr/assets"
OUTPUT_IMAGE="$OUTPUT_DIR/lock-image.png"
SIZE="250x250"

# --- Main ---
if [[ -z "$INPUT_IMAGE" ]]; then
    echo "Usage: $0 /path/to/your/image.png"
    exit 1
fi

if [[ ! -f "$INPUT_IMAGE" ]]; then
    echo "Error: Input file not found."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Generating rounded image..."
convert "$INPUT_IMAGE" -resize "$SIZE^" -gravity center -extent "$SIZE" \
    \( -size "$SIZE" xc:none -fill white -draw "circle 125,125 125,0" \) \
    -compose copy_opacity -composite -trim "$OUTPUT_IMAGE"

echo "Image generated successfully at $OUTPUT_IMAGE"