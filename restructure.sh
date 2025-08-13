#!/usr/bin/env bash
set -e
cd dotfiles
for dir in */; do
    pkg_name="${dir%/}"
    if [ "$pkg_name" != "git" ] && [ "$pkg_name" != "zsh" ]; then
        echo "Restructuring $pkg_name..."
        # Create the target directory
        mkdir -p "$pkg_name/.config"
        # Move all files from the package root into the new .config subdir
        # Note the quotes around "$pkg_name" to fix the shellcheck warning.
        mv "$pkg_name"/* "$pkg_name/.config/" 2>/dev/null || true
    fi
done
echo "Restructuring complete."