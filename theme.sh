#!/usr/bin/env bash

# Stop on first error
set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

# --- Helper Functions ---
print_info() { printf "\e[34m[INFO]\e[0m %s\n" "$1"; }
# This error function now has a sibling for usage messages that don't exit.
print_error() { printf "\e[31m[ERROR]\e[0m %s\n" "$1" >&2; exit 1; }

# --- Script Logic ---
# CORRECTED (Fixes SC2317 and SC2012)
if [[ $# -eq 0 ]]; then
    # Print usage and available themes without exiting immediately.
    printf "Usage: %s <theme_name>\n" "$0"
    print_info "Available themes:"
    # Use find for safe filename handling.
    find "$THEMES_DIR" -type f -name "*.json" | while read -r theme_file; do
        # Use basename to strip the path and the .json extension.
        printf "  %s\n" "$(basename "$theme_file" .json)"
    done
    # Now, exit the script. This makes the commands above "reachable".
    exit 1
fi

THEME_NAME="$1"
THEME_FILE="$THEMES_DIR/$THEME_NAME.json"

if [[ ! -f "$THEME_FILE" ]]; then
    print_error "Theme '$THEME_NAME' not found at '$THEME_FILE'"
fi

print_info "Applying theme: $THEME_NAME"

# Check for jq
if ! command -v jq &> /dev/null; then
    print_error "'jq' is not installed. Please install it to continue."
fi

# Create a sed script from the theme's JSON file
SED_SCRIPT=$(jq -r 'to_entries|map("s/##\(.key)##/\(.value)/g")|.[]' "$THEME_FILE")

# Find all template files and apply the theme
find "$DOTFILES_DIR" -type f -name "*.tmpl" | while read -r template_file; do
    destination_file="${template_file%.tmpl}"
    tmp_file=$(mktemp)
    sed "$SED_SCRIPT" "$template_file" > "$tmp_file"
    mv "$tmp_file" "$destination_file"
done

# Special handling for Neovim theme (workaround for Lua templating)
NVIM_THEME_LINE="vim.g.nvim_theme = \"$(jq -r '.nvim_theme' "$THEME_FILE")\""
sed -i "s/vim.g.nvim_theme = .*/${NVIM_THEME_LINE}/" "$DOTFILES_DIR/nvim/lua/plugins/colorscheme.lua"

print_info "Reloading applications to apply changes..."

# Reload Hyprland
hyprctl reload

# Reload AGS
ags -q "App.resetCss(); App.applyCss('./style.css');"

# Reload Tmux if running
if pgrep -x "tmux" > /dev/null; then
    tmux source-file ~/.config/tmux/tmux.conf
fi

# Set wallpaper
WALLPAPER_PATH=$(jq -r '.wallpaper' "$THEME_FILE")
if [[ -f "$WALLPAPER_PATH" ]]; then
    swww img "$WALLPAPER_PATH" --transition-type wipe --transition-fps 60
else
    print_error "Wallpaper not found at $WALLPAPER_PATH"
fi

print_info "Theme '$THEME_NAME' applied successfully!"