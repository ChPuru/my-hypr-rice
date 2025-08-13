#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
STOW_TARGET_DIR="$HOME"

# --- Main Logic ---
echo "Stowing all dotfiles for the full experience..."

# Get a list of all directories inside 'dotfiles', excluding the simple 'ags' config.
# This is the clean and correct way to build the package list.
PACKAGES_TO_STOW=$(find "$DOTFILES_DIR" -maxdepth 1 -mindepth 1 -type d -not -name "ags" -printf "%f ")

# Call stow ONCE with the correct stow directory and the full list of packages.
# This is the standard, most robust way to use stow.
stow -v -R -t "$STOW_TARGET_DIR" --dir="$DOTFILES_DIR" "$PACKAGES_TO_STOW"

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
stow -v -R -t "$STOW_TARGET_DIR/.config" --dir="$SCRIPT_DIR" "scripts"

echo "Stow complete."