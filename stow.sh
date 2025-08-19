#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
TARGET_HOME="$HOME"
TARGET_CONFIG="$HOME/.config"

# --- Helper Functions ---
print_info() { printf "\e[34m[INFO]\e[0m %s\n" "$1"; }
print_success() { printf "\e[32m[SUCCESS]\e[0m %s\n" "$1"; }
print_warning() { printf "\e[33m[WARNING]\e[0m %s\n" "$1"; }
print_error() { printf "\e[31m[ERROR]\e[0m %s\n" "$1"; }

# Check if stow is available
if ! command -v stow >/dev/null 2>&1; then
    print_error "GNU Stow is not installed. Install it with: sudo pacman -S stow"
fi

# --- Functions ---
stow_packages() {
    local target_dir="$1"
    shift
    local packages=("$@")
    local failed_packages=()
    
    for package in "${packages[@]}"; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            print_info "Stowing $package to $target_dir..."
            
            # Remove any existing directory that's not a symlink
            if [[ -d "$target_dir/$package" && ! -L "$target_dir/$package" ]]; then
                print_warning "Removing existing non-symlink directory: $target_dir/$package"
                rm -rf "${target_dir:?}/${package:?}"
            fi
            
            if stow -v -R -t "$target_dir" --dir="$DOTFILES_DIR" "$package" 2>/dev/null; then
                print_success "✓ Successfully stowed $package"
            else
                print_error "✗ Failed to stow $package"
                failed_packages+=("$package")
            fi
        else
            print_warning "⚠ Package directory $package not found, skipping..."
        fi
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        print_error "Failed packages: ${failed_packages[*]}"
        return 1
    fi
}

# --- Main Logic ---
print_info "Starting dotfiles stowing process..."

# Create target directories
mkdir -p "$TARGET_CONFIG"

# Clean up any previous stow attempts
print_info "Cleaning up previous stow attempts..."
cd "$DOTFILES_DIR"
for dir in */; do
    if [[ -d "$dir" ]]; then
        package="${dir%/}"
        print_info "Unstowing $package (cleanup)..."
        stow -D -t "$TARGET_HOME" "$package" 2>/dev/null || true
        stow -D -t "$TARGET_CONFIG" "$package" 2>/dev/null || true
    fi
done

# Determine which AGS config to use and verify it exists
AGS_CONFIG=""
if [[ -d "$DOTFILES_DIR/ags-advanced" ]] && find "$DOTFILES_DIR/ags-advanced" -type f | grep -q .; then
    AGS_CONFIG="ags-advanced"
    print_info "Using advanced AGS configuration"
elif [[ -d "$DOTFILES_DIR/ags" ]] && find "$DOTFILES_DIR/ags" -type f | grep -q .; then
    AGS_CONFIG="ags"
    print_info "Using simple AGS configuration"
else
    print_warning "No AGS configuration found!"
fi

# Auto-detect packages that actually exist and have content
print_info "Scanning for available packages..."
CONFIG_PACKAGES=()
for dir in "$DOTFILES_DIR"/*/; do
    if [[ -d "$dir" ]]; then
        package_name=$(basename "$dir")
        
        # Skip home packages
        if [[ "$package_name" == "git" || "$package_name" == "zsh" ]]; then
            continue
        fi
        
        # Check if directory has actual content (not just empty dirs)
        if find "$dir" -type f | grep -q .; then
            CONFIG_PACKAGES+=("$package_name")
            print_info "Found package: $package_name"
        else
            print_warning "Skipping empty package: $package_name"
        fi
    fi
done

# Auto-detect home packages
print_info "Scanning for home packages..."
HOME_PACKAGES=()
for package in "git" "zsh"; do
    if [[ -d "$DOTFILES_DIR/$package" ]] && find "$DOTFILES_DIR/$package" -type f | grep -q .; then
        HOME_PACKAGES+=("$package")
        print_info "Found home package: $package"
    else
        print_warning "Skipping missing/empty home package: $package"
    fi
done

print_info "Stowing config packages to $TARGET_CONFIG..."
if [[ ${#CONFIG_PACKAGES[@]} -gt 0 ]]; then
    if stow_packages "$TARGET_CONFIG" "${CONFIG_PACKAGES[@]}"; then
        print_success "Config packages stowed successfully"
    else
        print_warning "Some config packages failed to stow, but continuing..."
    fi
else
    print_warning "No config packages found to stow"
fi

print_info "Stowing home packages to $TARGET_HOME..."
if [[ ${#HOME_PACKAGES[@]} -gt 0 ]]; then
    if stow_packages "$TARGET_HOME" "${HOME_PACKAGES[@]}"; then
        print_success "Home packages stowed successfully"
    else
        print_warning "Some home packages failed to stow, but continuing..."
    fi
else
    print_warning "No home packages found to stow"
fi

# Stow the scripts directory
print_info "Stowing scripts directory..."
if [[ -d "$SCRIPT_DIR/scripts" ]]; then
    if stow -v -R -t "$TARGET_CONFIG" --dir="$SCRIPT_DIR" "scripts" 2>/dev/null; then
        print_success "✓ Successfully stowed scripts"
    else
        print_warning "✗ Failed to stow scripts (continuing anyway)"
    fi
else
    print_warning "⚠ Scripts directory not found, skipping..."
fi

print_success "Stow process completed!"

# Verify critical symlinks
print_info "Verifying critical symlinks..."
CRITICAL_CONFIGS=()
if [[ -n "$AGS_CONFIG" ]]; then
    CRITICAL_CONFIGS+=("$AGS_CONFIG")
fi

# Add other critical configs that should exist
for config in "hypr" "kitty" "nvim"; do
    if [[ -d "$DOTFILES_DIR/$config" ]]; then
        CRITICAL_CONFIGS+=("$config")
    fi
done

for config in "${CRITICAL_CONFIGS[@]}"; do
    if [[ -L "$TARGET_CONFIG/$config" ]]; then
        print_success "✓ $config is properly symlinked"
    else
        print_error "✗ $config is NOT symlinked"
    fi
done

print_info "Next steps:"
echo "1. Run: ./theme.sh catppuccin-mocha"
echo "2. Start Hyprland session"
echo "3. Check if AGS starts automatically"