#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
STOW_TARGET_DIR_CONFIG="$HOME/.config"
STOW_TARGET_DIR_HOME="$HOME"

# --- Main Logic ---
echo "Stowing all dotfiles..."

# --- Packages that go into ~/.config ---
# Most of our packages belong here.
CONFIG_PACKAGES=(
    ags-advanced alacritty anyrun auto-cpfrq avizo bash bottom btop cava
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

# Stow the config packages
echo "Stowing config packages to $STOW_TARGET_DIR_CONFIG..."
stow -v -R -t "$STOW_TARGET_DIR_CONFIG" --dir="$DOTFILES_DIR" "${CONFIG_PACKAGES[@]}"

# Stow the home packages
echo "Stowing home packages to $STOW_TARGET_DIR_HOME..."
stow -v -R -t "$STOW_TARGET_DIR_HOME" --dir="$DOTFILES_DIR" "${HOME_PACKAGES[@]}"

# Stow the top-level scripts directory separately
echo "Stowing scripts directory..."
stow -v -R -t "$STOW_TARGET_DIR_CONFIG" --dir="$SCRIPT_DIR" "scripts"

echo "Stow complete."