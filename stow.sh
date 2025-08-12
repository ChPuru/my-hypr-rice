#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
STOW_TARGET_DIR="$HOME"

# --- Main Logic ---
echo "Stowing all dotfiles for the full experience..."

# Stow all application configs from the 'dotfiles' directory
find "$DOTFILES_DIR" -maxdepth 1 -mindepth 1 -type d ! -name "ags" -exec stow -v -R -t "$STOW_TARGET_DIR" --dir="$DOTFILES_DIR" {} +

# Stow the top-level scripts directory to ~/.config/scripts
echo "Stowing scripts directory..."
# The -t flag sets the target. We want the 'scripts' folder to land inside '.config'
stow -v -R -t "$STOW_TARGET_DIR/.config" --dir="$SCRIPT_DIR" scripts

echo "Stow complete."