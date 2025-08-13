#!/usr/bin/env bash

set -e

# --- Globals ---
STOW_TARGET_DIR="$HOME"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/dotfiles"

# --- Main Logic ---
echo "Stowing all dotfiles..."

# This is the simplest and most robust way to use stow.
# It changes into the dotfiles directory and stows everything.
cd "$DOTFILES_DIR"

# Stow everything in this directory.
# The '--' ensures that any directory names starting with a dash are not
# treated as options, fixing shellcheck warning SC2035.
stow -v -R -t "$STOW_TARGET_DIR" -- */

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
cd ..
stow -v -R -t "$STOW_TARGET_DIR/.config" "scripts"

echo "Stow complete."