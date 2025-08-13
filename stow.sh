#!/usr/bin/env bash

set -e

# --- Globals ---
STOW_TARGET_HOME="$HOME"
STOW_TARGET_CONFIG="$HOME/.config"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/dotfiles"

# --- Main Logic ---
echo "Stowing all dotfiles..."

# --- Packages that go into ~/.config ---
# This is an explicit list of every package that belongs in .config.
# This is the most robust method.
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
# These have files that need to be in the root of the home dir, like .zshrc
HOME_PACKAGES=(
    git
    zsh
)

# Stow the config packages from the project root.
echo "Stowing config packages to $STOW_TARGET_CONFIG..."
stow -v -R -t "$STOW_TARGET_CONFIG" --dir="$DOTFILES_DIR" "${CONFIG_PACKAGES[@]}"

# Stow the home packages from the project root.
echo "Stowing home packages to $STOW_TARGET_HOME..."
stow -v -R -t "$STOW_TARGET_HOME" --dir="$DOTFILES_DIR" "${HOME_PACKAGES[@]}"

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
stow -v -R -t "$STOW_TARGET_CONFIG" "scripts"

echo "Stow complete."