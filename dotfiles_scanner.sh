#!/usr/bin/env bash

# Scan the dotfiles directory to see what we actually have

DOTFILES_DIR="./dotfiles"

echo "=== DOTFILES DIRECTORY ANALYSIS ==="
echo

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "ERROR: $DOTFILES_DIR not found!"
    exit 1
fi

echo "Scanning $DOTFILES_DIR..."
echo

# Count total directories
TOTAL_DIRS=$(find "$DOTFILES_DIR" -maxdepth 1 -type d | wc -l)
echo "Total subdirectories: $((TOTAL_DIRS - 1))"  # Subtract 1 for the dotfiles dir itself
echo

# Check each directory
echo "=== DIRECTORY CONTENTS ==="
for dir in "$DOTFILES_DIR"/*/; do
    if [[ -d "$dir" ]]; then
        package_name=$(basename "$dir")
        file_count=$(find "$dir" -type f | wc -l)
        
        if [[ $file_count -gt 0 ]]; then
            echo "✓ $package_name ($file_count files)"
            # Show first few files as examples
            find "$dir" -type f | head -3 | sed 's|^|    |'
            if [[ $file_count -gt 3 ]]; then
                echo "    ... and $((file_count - 3)) more files"
            fi
        else
            echo "✗ $package_name (EMPTY - no files found)"
        fi
        echo
    fi
done

echo "=== RECOMMENDED STOW PACKAGES ==="
echo "Based on what's available, you should stow:"
echo

CONFIG_PACKAGES=()
HOME_PACKAGES=()

for dir in "$DOTFILES_DIR"/*/; do
    if [[ -d "$dir" ]]; then
        package_name=$(basename "$dir")
        
        if find "$dir" -type f | grep -q .; then
            if [[ "$package_name" == "git" || "$package_name" == "zsh" ]]; then
                HOME_PACKAGES+=("$package_name")
            else
                CONFIG_PACKAGES+=("$package_name")
            fi
        fi
    fi
done

echo "CONFIG packages (go to ~/.config/):"
for pkg in "${CONFIG_PACKAGES[@]}"; do
    echo "  - $pkg"
done

echo
echo "HOME packages (go to ~/):"
for pkg in "${HOME_PACKAGES[@]}"; do
    echo "  - $pkg"
done

echo
echo "=== TOTAL ==="
echo "Config packages: ${#CONFIG_PACKAGES[@]}"
echo "Home packages: ${#HOME_PACKAGES[@]}"

if [[ ${#CONFIG_PACKAGES[@]} -eq 0 && ${#HOME_PACKAGES[@]} -eq 0 ]]; then
    echo
    echo "ERROR: No packages with files found!"
    echo "This suggests that either:"
    echo "1. The dotfiles haven't been properly prepared"
    echo "2. You need to run the restructure script first"
    echo "3. There's an issue with the directory structure"
fi