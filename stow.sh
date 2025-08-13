#!/usr/bin/env bash

set -e

# --- Globals ---
STOW_TARGET_HOME="$HOME"
STOW_TARGET_CONFIG="$HOME/.config"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/dotfiles"

# --- Functions ---
stow_packages() {
    local target_dir="$1"
    local packages=("${@:2}")
    local failed_packages=()
    
    for package in "${packages[@]}"; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            echo "Stowing $package to $target_dir..."
            if stow -v -R -t "$target_dir" --dir="$DOTFILES_DIR" "$package"; then
                echo "✓ Successfully stowed $package"
            else
                echo "✗ Failed to stow $package"
                failed_packages+=("$package")
            fi
        else
            echo "⚠ Package directory $package not found, skipping..."
        fi
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        echo "Failed packages: ${failed_packages[*]}"
        return 1
    fi
}

# --- Main Logic ---
echo "Cleaning up existing stowed dotfiles..."

# First, try to unstow everything to clean up conflicts
echo "Attempting to unstow existing packages..."
cd "$DOTFILES_DIR"
for dir in */; do
    if [[ -d "$dir" ]]; then
        package="${dir%/}"
        echo "Unstowing $package..."
        stow -D -t "$STOW_TARGET_HOME" "$package" 2>/dev/null || true
        stow -D -t "$STOW_TARGET_CONFIG" "$package" 2>/dev/null || true
    fi
done

echo "Stowing all dotfiles..."

# --- Packages that go into ~/.config ---
CONFIG_PACKAGES=(
    ags-advanced alacritty anyrun auto-cpufreq avizo bash bottom btop cava
    cool-retro-term dolphin dunst eww fastfetch fish fnott fontconfig foot
    fuzzel gamemode gammastep gtk-3.0 gtk-4.0 helix htop hypr hyprlock
    hyprnotify hyprpaper ironbar kanshi kitty kvantum lutris ly mako mangohud
    mpv nemo neofetch nvim nwg-dock-hyprland nwg-look nwg-panel pipewire
    qt5ct qt6ct ranger rofi starship swaybg swaylock swaylock-effects swaync
    swww thunar tlp tmux tofi vis waybar wezterm wireplumber wlogout
    wlsunset wluma wofi wpaperd yambar yazi zathura
)

# --- Packages that go into ~ (home directory) ---
HOME_PACKAGES=(
    git
    zsh
)

# Stow the config packages
echo "Stowing config packages to $STOW_TARGET_CONFIG..."
if ! stow_packages "$STOW_TARGET_CONFIG" "${CONFIG_PACKAGES[@]}"; then
    echo "Some config packages failed to stow. Continue anyway? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Aborting due to config package failures."
        exit 1
    fi
fi

# Stow the home packages
echo "Stowing home packages to $STOW_TARGET_HOME..."
if ! stow_packages "$STOW_TARGET_HOME" "${HOME_PACKAGES[@]}"; then
    echo "Some home packages failed to stow. Continue anyway? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Aborting due to home package failures."
        exit 1
    fi
fi

# Stow the scripts directory
echo "Stowing scripts directory..."
if [[ -d "scripts" ]]; then
    if stow -v -R -t "$STOW_TARGET_CONFIG" --dir="." "scripts"; then
        echo "✓ Successfully stowed scripts"
    else
        echo "✗ Failed to stow scripts"
    fi
elif [[ -d "$DOTFILES_DIR/scripts" ]]; then
    if stow -v -R -t "$STOW_TARGET_CONFIG" --dir="$DOTFILES_DIR" "scripts"; then
        echo "✓ Successfully stowed scripts"
    else
        echo "✗ Failed to stow scripts"
    fi
else
    echo "⚠ Scripts directory not found, skipping..."
fi

echo "Stow complete."