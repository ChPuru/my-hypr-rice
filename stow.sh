#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="dotfiles" # Use a relative path, it's cleaner
STOW_TARGET_DIR="$HOME"

# --- Main Logic ---
echo "Stowing all dotfiles for the full experience..."

# We stay in the root directory of the project.
# The --dir flag tells stow that all our packages are located inside the 'dotfiles' folder.

# Get a list of all directories inside 'dotfiles'
# We use find to get clean names without './'
PACKAGES=$(find "$DOTFILES_DIR" -maxdepth 1 -mindepth 1 -type d -printf "%f\n")

for pkg in $PACKAGES; do
    # Skip the simple 'ags' config, as we want the advanced one
    if [ "$pkg" != "ags" ]; then
        echo "Stowing package: $pkg"
        stow -v -R -t "$STOW_TARGET_DIR" --dir="$DOTFILES_DIR" "$pkg"
    fi
done

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
# The --dir is '.' because 'scripts' is in the current directory.
stow -v -R -t "$STOW_TARGET_DIR/.config" --dir="." "scripts"

echo "Stow complete."