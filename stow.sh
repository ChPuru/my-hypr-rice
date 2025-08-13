#!/usr/bin/env bash

set -e

# --- Globals ---
STOW_TARGET_DIR="$HOME"

# --- Main Logic ---
echo "Stowing all dotfiles..."

# This is the simplest and most robust way to use stow for a full setup.
# It tells stow to look in the current directory for a folder named 'dotfiles'
# and then link all of its contents to the target directory (~).
stow -v -R -t "$STOW_TARGET_DIR" dotfiles

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
stow -v -R -t "$STOW_TARGET_DIR/.config" "scripts"

echo "Stow complete."