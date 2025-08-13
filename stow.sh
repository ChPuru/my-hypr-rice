#!/usr/bin/env bash

set -e

# --- Globals ---
STOW_TARGET_HOME="$HOME"
STOW_TARGET_CONFIG="$HOME/.config"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/dotfiles"

# --- Main Logic ---
echo "Stowing all dotfiles..."

# Loop through every package in the dotfiles directory
cd "$DOTFILES_DIR"
for pkg_name in */; do
    # Remove the trailing slash
    pkg_name="${pkg_name%/}"

    # Default target is ~/.config
    TARGET="$STOW_TARGET_CONFIG"

    # Packages that need to be stowed directly to ~
    if [[ "$pkg_name" == "git" || "$pkg_name" == "zsh" ]]; then
        TARGET="$STOW_TARGET_HOME"
    fi
    
    echo "Stowing '$pkg_name' to '$TARGET'..."
    # The --dir is '..' because we are inside the dotfiles folder.
    stow -v -R -t "$TARGET" --dir=".." "$pkg_name"
done

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
cd ..
stow -v -R -t "$STOW_TARGET_CONFIG" "scripts"

echo "Stow complete."