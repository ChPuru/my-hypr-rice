#!/usr/bin/env bash

# This script safely removes all symlinks created by stow.

set -e

# --- Globals ---
DOTFILES_DIR="dotfiles"
STOW_TARGET_DIR="$HOME"

echo "--- Removing all old symlinks ---"

# Get a list of all directories inside 'dotfiles'
PACKAGES=$(find "$DOTFILES_DIR" -maxdepth 1 -mindepth 1 -type d -printf "%f\n")

for pkg in $PACKAGES; do
    # We don't care which AGS config was stowed, so we try to unstow both.
    # It's okay if one of these fails with "package not found".
    echo "Attempting to unstow package: $pkg"
    stow -D -v -t "$STOW_TARGET_DIR" --dir="$DOTFILES_DIR" "$pkg" || true
done

# Unstow the scripts directory
echo "Attempting to unstow scripts directory..."
stow -D -v -t "$STOW_TARGET_DIR/.config" --dir="." "scripts" || true

echo "--- Cleanup complete ---"
print_success "All existing symlinks have been removed. You can now run stow.sh again."
