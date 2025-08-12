#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
CACHE_DIR="$HOME/.cache/wal"

# --- Helper Functions ---
print_info() { printf "\e[34m[INFO]\e[0m %s\n" "$1"; }
print_error() { printf "\e[31m[ERROR]\e[0m %s\n" "$1" >&2; exit 1; }

# --- Main Logic ---

# Function to apply theme from a prepared JSON file
apply_theme() {
    local theme_file="$1"
    print_info "Applying theme from $theme_file"

    # Create sed script from JSON
    SED_SCRIPT=$(jq -r 'to_entries|map("s/##\(.key)##/\(.value)/g")|.[]' "$theme_file")

    # Apply to all template files
    find "$DOTFILES_DIR" -type f -name "*.tmpl" | while read -r template_file; do
        destination_file="${template_file%.tmpl}"
        tmp_file=$(mktemp)
        sed "$SED_SCRIPT" "$template_file" > "$tmp_file"
        mv "$tmp_file" "$destination_file"
    done

    # Special handling for Neovim theme
    NVIM_THEME_LINE="vim.g.nvim_theme = \"$(jq -r '.nvim_theme' "$theme_file")\""
    sed -i "s/vim.g.nvim_theme = .*/${NVIM_THEME_LINE}/" "$DOTFILES_DIR/nvim/lua/plugins/colorscheme.lua"

    # Set wallpaper
    WALLPAPER_PATH=$(jq -r '.wallpaper' "$theme_file")
    if [[ -f "$WALLPAPER_PATH" ]]; then
        swww img "$WALLPAPER_PATH" --transition-type wipe --transition-fps 60
    else
        print_error "Wallpaper not found at $WALLPAPER_PATH"
    fi
}

# --- Script Entry Point ---

if [[ "$1" == "--from-wallpaper" ]]; then
    # --- Pywal Mode ---
    WALLPAPER_INPUT="$2"
    if [[ ! -f "$WALLPAPER_INPUT" ]]; then
        print_error "Wallpaper file not found: $WALLPAPER_INPUT"
    fi
    
    print_info "Generating theme from wallpaper: $WALLPAPER_INPUT"
    wal -i "$WALLPAPER_INPUT" -n -q -s

    print_info "Creating theme mapping from pywal cache..."
    # Create a temporary JSON file that maps pywal's output to our template format
    TEMP_THEME_FILE=$(mktemp --suffix=.json)
    jq -n \
      --arg wallpaper "$(jq -r '.wallpaper' "$CACHE_DIR/colors.json")" \
      --arg background "$(jq -r '.special.background' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg foreground "$(jq -r '.special.foreground' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg mauve "$(jq -r '.colors.color5' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg blue "$(jq -r '.colors.color4' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg red "$(jq -r '.colors.color1' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg nvim_theme "catppuccin" \
      '{
        wallpaper: $wallpaper,
        background: $background,
        foreground: $foreground,
        text: $foreground,
        mauve: $mauve,
        blue: $blue,
        red: $red,
        crust: $background,
        mantle: $background,
        surface0: $background,
        surface1: $background,
        surface2: $background,
        subtext1: $foreground,
        sky: $blue,
        nvim_theme: $nvim_theme
      }' > "$TEMP_THEME_FILE"

    apply_theme "$TEMP_THEME_FILE"
    rm "$TEMP_THEME_FILE"

else
    # --- Pre-made Theme Mode ---
    THEME_NAME="$1"
    THEME_FILE="$THEMES_DIR/$THEME_NAME.json"
    if [[ -z "$THEME_NAME" ]]; then
        print_error "Usage: $0 <theme_name> OR $0 --from-wallpaper /path/to/image"
    fi
    if [[ ! -f "$THEME_FILE" ]]; then
        print_error "Theme '$THEME_NAME' not found."
    fi
    apply_theme "$THEME_FILE"
fi

print_info "Reloading applications..."
ags -q "App.resetCss(); App.applyCss(App.configDir + '/style.css');"
hyprctl reload

print_success "Theme applied successfully!"