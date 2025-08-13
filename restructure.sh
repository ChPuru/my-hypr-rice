#!/usr/bin/env bash
set -e
echo "--- Starting Directory Restructuring ---"
cd dotfiles

for dir in */; do
    pkg_name="${dir%/}"
    echo "Processing package: $pkg_name"

    # Create a temporary directory for the correct structure
    mkdir -p "/tmp/restructure/$pkg_name"

    if [[ "$pkg_name" == "git" || "$pkg_name" == "zsh" ]]; then
        # These packages go directly into the home directory
        # MODIFICATION: Added '2>/dev/null || true' to handle empty directories
        mv "$pkg_name"/* "/tmp/restructure/$pkg_name/" 2>/dev/null || true
    else
        # All other packages go into .config
        mkdir -p "/tmp/restructure/$pkg_name/.config/$pkg_name"
        # MODIFICATION: Added '2>/dev/null || true' to handle empty directories
        mv "$pkg_name"/* "/tmp/restructure/$pkg_name/.config/$pkg_name/" 2>/dev/null || true
    fi

    # Replace the old, incorrect directory with the new, correct one
    rm -rf "$pkg_name"
    mv "/tmp/restructure/$pkg_name" .
done

rm -rf "/tmp/restructure"
echo "--- Restructuring Complete ---"