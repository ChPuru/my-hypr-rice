#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
STOW_TARGET_DIR="$HOME"

# --- Main Logic ---
echo "Stowing all dotfiles for the full experience..."

# Change into the dotfiles directory to work with clean package names
cd "$DOTFILES_DIR"

# Stow all directories inside this folder, EXCEPT for the simple 'ags' config.
# We use a loop to call stow on each directory individually.
for dir in */; do
    # Remove the trailing slash from the directory name
    pkg_name="${dir%/}"
    
    # Skip the 'ags' directory, as we want 'ags-advanced'
    if [ "$pkg_name" != "ags" ]; then
        echo "Stowing package: $pkg_name"
        # The --dir is now '..' because we are inside the dotfiles folder.
        # The target is our home directory.
        stow -v -R -t "$STOW_TARGET_DIR" --dir=".." "$pkg_name"
    fi
done

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
cd "$SCRIPT_DIR"
stow -v -R -t "$STOW_TARGET_DIR/.config" --dir="." "scripts"

echo "Stow complete."