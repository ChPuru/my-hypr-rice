#!/usr/bin/env bash

set -e

# --- Globals ---
# The directory where our packages are located.
STOW_DIR_DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/dotfiles"

# The target directories.
TARGET_HOME="$HOME"
TARGET_CONFIG="$HOME/.config"

# --- Main Logic ---
echo "Stowing all dotfiles..."

# This is the most robust method. We change into the directory containing the packages.
cd "$STOW_DIR_DOTFILES"

# --- Packages that go into ~/.config ---
# We tell stow to link these packages into the parent directory's .config folder.
echo "Stowing config packages to $TARGET_CONFIG..."
stow -v -R -t "$TARGET_CONFIG" \
    ags-advanced alacritty anyrun auto-cpufreq avizo bash bottom btop cava \
    cool-retro-term dolphin dunst eww fastfetch fish fnott fontconfig foot \
    fuzzel gamemode gammastep gtk-3.0 gtk-4.0 helix htop hypr hyprlock \
    hyprnotify hyprpaper ironbar kanshi kitty kvantum lutris ly mako mangohud \
    mpv nemo neofetch nvim nwg-dock-hyprland nwg-look nwg-panel pipewire \
    qt5ct qt6ct ranger rofi starship swaybg swaylock swaylock-effects swaync \
    swww thunar tlp tmux tofi vis waybar wezterm wireplumber wlogout \
    wlsunset wluma wofi wpaperd yambar yazi zathura

# --- Packages that go into ~ (home directory) ---
# These have files that need to be in the root of the home dir, like .zshrc
echo "Stowing home packages to $TARGET_HOME..."
stow -v -R -t "$TARGET_HOME" git zsh

# --- Stow the top-level scripts directory separately ---
echo "Stowing scripts directory..."
# We go back to the project root to handle this one.
cd ..
stow -v -R -t "$TARGET_CONFIG" scripts

echo "Stow complete."