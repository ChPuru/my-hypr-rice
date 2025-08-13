#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
STOW_TARGET_DIR="$HOME"

# --- Main Logic ---
echo "Stowing all dotfiles for the full experience..."

# Define an explicit list of all packages to be stowed from the 'dotfiles' directory.
# This is the most robust method.
PACKAGES=(
    ags-advanced
    alacritty
    anyrun
    auto-cpufreq
    avizo
    bash
    bottom
    btop
    cava
    cool-retro-term
    dolphin
    dunst
    eww
    fastfetch
    fish
    fnott
    fontconfig
    foot
    fuzzel
    gamemode
    gammastep
    git
    glava
    gtk-3.0
    gtk-4.0
    helix
    htop
    hypr
    hyprlock
    hyprnotify
    hyprpaper
    ironbar
    kanshi
    kitty
    kvantum
    lutris
    ly
    mako
    mangohud
    mpv
    nemo
    neofetch
    nvim
    nwg-dock-hyprland
    nwg-look
    nwg-panel
    pipewire
    qt5ct
    qt6ct
    ranger
    rofi
    starship
    swaybg
    swaylock
    swaylock-effects
    swaync
    swww
    thunar
    tlp
    tmux
    tofi
    vis
    waybar
    wezterm
    wireplumber
    wlogout
    wlsunset
    wluma
    wofi
    wpaperd
    yambar
    yazi
    zathura
    zsh
)

# Call stow ONCE with the correct stow directory and the full list of packages.
stow -v -R -t "$STOW_TARGET_DIR" --dir="$DOTFILES_DIR" "${PACKAGES[@]}"

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
stow -v -R -t "$STOW_TARGET_DIR/.config" --dir="$SCRIPT_DIR" "scripts"

echo "Stow complete."