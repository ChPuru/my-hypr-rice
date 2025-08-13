#!/usr/bin/env bash

set -e

# --- Globals ---
STOW_TARGET_DIR="$HOME"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/dotfiles"

# --- Functions ---
handle_conflicts() {
    local package="$1"
    echo "Checking for conflicts in package: $package"
    
    # Dry run to check for conflicts
    if ! stow -n -v -R -t "$STOW_TARGET_DIR" "$package" 2>/dev/null; then
        echo "Conflicts detected in $package. Options:"
        echo "1. Skip this package"
        echo "2. Remove conflicting files and continue"
        echo "3. Adopt conflicting files into dotfiles repo"
        echo "4. Abort"
        
        read -r "Choose (1-4): " choice
        
        case $choice in
            1)
                echo "Skipping $package"
                return 1
                ;;
            2)
                echo "Please manually remove conflicting files and re-run"
                stow -n -v -R -t "$STOW_TARGET_DIR" "$package"
                return 1
                ;;
            3)
                echo "Adopting files for $package"
                stow -v -R --adopt -t "$STOW_TARGET_DIR" "$package"
                return 0
                ;;
            4)
                echo "Aborting"
                exit 1
                ;;
            *)
                echo "Invalid choice"
                return 1
                ;;
        esac
    fi
    return 0
}

# --- Main Logic ---
echo "Stowing all dotfiles..."

cd "$DOTFILES_DIR"

# Process each package individually to handle conflicts better
for package in */; do
    package="${package%/}"  # Remove trailing slash
    
    if [[ -d "$package" ]]; then
        echo "Processing package: $package"
        
        if handle_conflicts "$package"; then
            stow -v -R -t "$STOW_TARGET_DIR" "$package"
            echo "✓ Successfully stowed $package"
        else
            echo "✗ Skipped $package due to conflicts"
        fi
    fi
done

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
cd ..
if [[ -d "scripts" ]]; then
    if handle_conflicts "scripts"; then
        stow -v -R -t "$STOW_TARGET_DIR/.config" "scripts"
        echo "✓ Successfully stowed scripts"
    else
        echo "✗ Skipped scripts due to conflicts"
    fi
fi

echo "Stow complete."