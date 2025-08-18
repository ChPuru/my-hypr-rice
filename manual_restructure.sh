#!/usr/bin/env bash

set -e

echo "=== MANUAL DOTFILES RESTRUCTURE ==="

# This script manually creates the correct stow structure for the files we know exist

DOTFILES_DIR="./dotfiles"

# Backup existing structure
if [[ -d "$DOTFILES_DIR" ]]; then
    echo "Backing up existing dotfiles directory..."
    cp -r "$DOTFILES_DIR" "${DOTFILES_DIR}.backup.$(date +%s)"
fi

# Create new structure
mkdir -p "$DOTFILES_DIR"

# Function to create stow package structure
create_stow_package() {
    local package_name="$1"
    local config_path="$2"  # Path within .config/ or empty for home directory
    
    if [[ -n "$config_path" ]]; then
        # Config package: create .config/package_name structure
        mkdir -p "$DOTFILES_DIR/$package_name/.config/$package_name"
        target_dir="$DOTFILES_DIR/$package_name/.config/$package_name"
    else
        # Home package: files go directly in package directory
        mkdir -p "$DOTFILES_DIR/$package_name"
        target_dir="$DOTFILES_DIR/$package_name"
    fi
    
    echo "$target_dir"
}

echo "Creating proper stow structure..."

# Create AGS package (we know these files exist)
if [[ -f "dotfiles/ags/config.js.tmpl" ]]; then
    AGS_TARGET=$(create_stow_package "ags" "ags")
    cp -r dotfiles/ags-original/modules "$AGS_TARGET/" 2>/dev/null || true
    cp dotfiles/ags/config.js.tmpl "$AGS_TARGET/" 2>/dev/null || true
    cp dotfiles/ags/style.css.tmpl "$AGS_TARGET/" 2>/dev/null || true
    echo "✓ Created AGS package"
fi

# Create AGS Advanced package
if [[ -d "dotfiles/ags-advanced" ]]; then
    AGS_ADV_TARGET=$(create_stow_package "ags-advanced" "ags")
    cp -r dotfiles/ags-advanced/* "$AGS_ADV_TARGET/" 2>/dev/null || true
    echo "✓ Created AGS Advanced package"
fi

# Create Hyprland package
if [[ -f "dotfiles/hypr/hyprland.conf.tmpl" ]]; then
    HYPR_TARGET=$(create_stow_package "hypr" "hypr")
    cp dotfiles/hypr/* "$HYPR_TARGET/" 2>/dev/null || true
    echo "✓ Created Hyprland package"
fi

# Create Kitty package  
if [[ -f "dotfiles/kitty/kitty.conf.tmpl" ]]; then
    KITTY_TARGET=$(create_stow_package "kitty" "kitty")
    cp -r dotfiles/kitty/* "$KITTY_TARGET/" 2>/dev/null || true
    echo "✓ Created Kitty package"
fi

# Create Neovim package
if [[ -f "dotfiles/nvim/init.lua" ]]; then
    NVIM_TARGET=$(create_stow_package "nvim" "nvim")
    cp -r dotfiles/nvim/* "$NVIM_TARGET/" 2>/dev/null || true
    echo "✓ Created Neovim package"
fi

# Create other packages that have actual content
PACKAGES_WITH_CONTENT=(
    "btop:btop.conf.tmpl"
    "cava:config.tmpl" 
    "fastfetch:config.jsonc.tmpl"
    "fontconfig:fonts.conf"
    "gamemode:gamemode.ini"
    "gtk-3.0:settings.ini.tmpl"
    "gtk-4.0:settings.ini.tmpl"
    "hyprlock:hyprlock.conf.tmpl"
    "kvantum:kvantum.kvconfig.tmpl"
    "mangohud:MangoHud.conf.tmpl"
    "qt6ct:qt6ct.conf.tmpl"
    "starship:starship.toml.tmpl"
    "tmux:tmux.conf.tmpl"
    "wofi:style.css.tmpl"
    "yazi:theme.toml.tmpl"
)

for package_info in "${PACKAGES_WITH_CONTENT[@]}"; do
    IFS=: read -r package_name test_file <<< "$package_info"
    
    if [[ -f "dotfiles/$package_name/$test_file" ]]; then
        TARGET=$(create_stow_package "$package_name" "$package_name")
        cp -r "dotfiles/$package_name"/* "$TARGET/" 2>/dev/null || true
        echo "✓ Created $package_name package"
    fi
done

# Handle home directory packages
if [[ -f "dotfiles/git/.gitconfig.tmpl" ]]; then
    GIT_TARGET=$(create_stow_package "git" "")
    cp -r dotfiles/git/.* "$GIT_TARGET/" 2>/dev/null || true
    echo "✓ Created Git package"
fi

if [[ -f "dotfiles/zsh/.zshrc.tmpl" ]]; then
    ZSH_TARGET=$(create_stow_package "zsh" "")
    cp -r dotfiles/zsh/.* "$ZSH_TARGET/" 2>/dev/null || true
    echo "✓ Created Zsh package"
fi

echo
echo "=== STRUCTURE VERIFICATION ==="
echo "Checking created packages:"

for dir in "$DOTFILES_DIR"/*/; do
    if [[ -d "$dir" ]]; then
        package_name=$(basename "$dir")
        file_count=$(find "$dir" -type f | wc -l)
        
        if [[ $file_count -gt 0 ]]; then
            echo "✓ $package_name ($file_count files)"
        else
            echo "✗ $package_name (empty)"
            rm -rf "$dir"  # Remove empty directories
        fi
    fi
done

echo
echo "Manual restructure complete!"
echo "Now you can run: ./stow.sh"