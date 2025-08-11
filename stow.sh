#!/usr/bin/env bash

# Stop on first error
set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
# Stow targets the parent directory of the location of the dotfiles
STOW_TARGET_DIR="$HOME"

# --- Main Logic ---
# The -v flag is for verbose, -R for restow (relink), -t for target.
# We are stowing all directories inside the 'dotfiles' directory.
# The 'dot' argument at the end tells stow to process all packages in the current directory.
stow -v -R -t "$STOW_TARGET_DIR" --dir="$DOTFILES_DIR" .