#!/usr/bin/env bash

set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
CACHE_DIR="$HOME/.cache/wal"

# --- Helper Functions ---
print_info() { printf "\e[34m[INFO]\e[0m %s\n" "$1"; }
print_success() { printf "\e[32m[SUCCESS]\e[0m %s\n" "$1"; }
print_error() { printf "\e[31m[ERROR]\e[0m %s\n" "$1" >&2; exit 1; }

# --- Main Logic ---

# Function to apply theme from a prepared JSON file
apply_theme() {
    local theme_file="$1"
    print_info "Applying theme from $theme_file"

    if [[ ! -f "$theme_file" ]]; then
        print_error "Theme file not found: $theme_file"
    fi

    # Create temporary sed script
    local sed_script
    sed_script=$(mktemp)
    
    # Generate sed commands from JSON
    jq -r 'to_entries[] | "s/##\(.key)##/\(.value)/g"' "$theme_file" > "$sed_script"
    
    print_info "Processing template files..."
    
    # Apply to all template files
    find "$DOTFILES_DIR" -type f -name "*.tmpl" | while read -r template_file; do
        local destination_file="${template_file%.tmpl}"
        print_info "Processing: $(basename "$template_file")"
        
        # Apply sed script to template
        if sed -f "$sed_script" "$template_file" > "$destination_file"; then
            print_info "✓ Generated: $(basename "$destination_file")"
        else
            print_error "✗ Failed to process: $(basename "$template_file")"
        fi
    done
    
    rm "$sed_script"

    # Special handling for Neovim theme
    local nvim_theme
    nvim_theme=$(jq -r '.nvim_theme // "catppuccin"' "$theme_file")
    local nvim_colorscheme_file="$DOTFILES_DIR/nvim/lua/plugins/colorscheme.lua"
    
    if [[ -f "$nvim_colorscheme_file" ]]; then
        sed -i "s/vim.g.nvim_theme = .*/vim.g.nvim_theme = \"$nvim_theme\"/" "$nvim_colorscheme_file"
        print_info "✓ Updated Neovim theme to: $nvim_theme"
    fi

    # Set wallpaper if swww is available
    local wallpaper_path
    wallpaper_path=$(jq -r '.wallpaper // ""' "$theme_file")
    if [[ -n "$wallpaper_path" && -f "$wallpaper_path" ]]; then
        if command -v swww >/dev/null 2>&1; then
            print_info "Setting wallpaper: $wallpaper_path"
            # Initialize swww if not running
            if ! pgrep -x swww-daemon >/dev/null; then
                swww init &
                sleep 2
            fi
            swww img "$wallpaper_path" --transition-type wipe --transition-fps 60 2>/dev/null || {
                print_info "Note: Wallpaper setting failed (swww might not be in Wayland session)"
            }
        else
            print_info "swww not available, skipping wallpaper"
        fi
    fi
    
    print_success "Theme processing completed!"
}

# Function to create theme from pywal
create_pywal_theme() {
    local wallpaper_input="$1"
    
    if [[ ! -f "$wallpaper_input" ]]; then
        print_error "Wallpaper file not found: $wallpaper_input"
    fi
    
    if ! command -v wal >/dev/null 2>&1; then
        print_error "python-pywal not installed. Install it with: pacman -S python-pywal"
    fi
    
    print_info "Generating theme from wallpaper: $wallpaper_input"
    
    # Generate pywal colors
    wal -i "$wallpaper_input" -n -q -s
    
    if [[ ! -f "$CACHE_DIR/colors.json" ]]; then
        print_error "Pywal failed to generate colors"
    fi
    
    print_info "Creating theme mapping from pywal cache..."
    
    # Create a temporary JSON file that maps pywal's output to our template format
    local temp_theme_file
    temp_theme_file=$(mktemp --suffix=.json)
    
    # Extract colors from pywal and create our theme format
    jq -n \
      --arg wallpaper "$(jq -r '.wallpaper // ""' "$CACHE_DIR/colors.json")" \
      --arg background "$(jq -r '.special.background' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg foreground "$(jq -r '.special.foreground' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg color0 "$(jq -r '.colors.color0' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg color1 "$(jq -r '.colors.color1' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg color2 "$(jq -r '.colors.color2' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg color3 "$(jq -r '.colors.color3' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg color4 "$(jq -r '.colors.color4' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg color5 "$(jq -r '.colors.color5' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg color6 "$(jq -r '.colors.color6' "$CACHE_DIR/colors.json" | tr -d '#')" \
      --arg color7 "$(jq -r '.colors.color7' "$CACHE_DIR/colors.json" | tr -d '#')" \
      '{
        wallpaper: $wallpaper,
        font_main: "JetBrainsMono Nerd Font",
        font_size: "11",
        lockscreen_image: ($ENV.HOME + "/.config/hypr/assets/lock-image.png"),
        lockscreen_welcome_text: "Welcome back!",
        nvim_theme: "catppuccin",
        gtk_theme: "Catppuccin-Mocha-Standard-Blue-dark",
        kvantum_theme: "Catppuccin-Mocha",
        icon_theme: "Papirus-Dark",
        cursor_theme: "Bibata-Modern-Classic",
        background: $background,
        foreground: $foreground,
        text: $foreground,
        black: $color0,
        red: $color1,
        green: $color2,
        yellow: $color3,
        blue: $color4,
        magenta: $color5,
        cyan: $color6,
        white: $color7,
        gray: $color0,
        mauve: $color5,
        sky: $color6,
        crust: $background,
        mantle: $background,
        surface0: $color0,
        surface1: $color0,
        surface2: $color7,
        subtext1: $foreground,
        overlay0: $color0,
        overlay1: $color7,
        overlay2: $color7,
        base: $background,
        rosewater: $foreground,
        flamingo: $foreground,
        pink: $color5,
        maroon: $color1,
        peach: $color3,
        teal: $color6,
        lavender: $color4,
        subtext0: $foreground,
        hud_foreground: $foreground,
        hud_background: $background,
        hud_accent: $color4
      }' > "$temp_theme_file"

    apply_theme "$temp_theme_file"
    rm "$temp_theme_file"
}

# --- Script Entry Point ---

if [[ $# -eq 0 ]]; then
    print_error "Usage: $0 <theme_name> OR $0 --from-wallpaper /path/to/image"
fi

if [[ "$1" == "--from-wallpaper" ]]; then
    # --- Pywal Mode ---
    if [[ -z "$2" ]]; then
        print_error "Usage: $0 --from-wallpaper /path/to/wallpaper"
    fi
    create_pywal_theme "$2"
else
    # --- Pre-made Theme Mode ---
    THEME_NAME="$1"
    THEME_FILE="$THEMES_DIR/$THEME_NAME.json"
    
    if [[ ! -f "$THEME_FILE" ]]; then
        print_error "Theme '$THEME_NAME' not found at $THEME_FILE"
    fi
    
    apply_theme "$THEME_FILE"
fi

print_info "Reloading applications..."

# Reload AGS if it's running
if pgrep -x ags >/dev/null; then
    print_info "Reloading AGS..."
    ags -q || true
    sleep 1
    ags &
fi

# Reload Hyprland if we're in a Hyprland session
if command -v hyprctl >/dev/null 2>&1 && pgrep -x Hyprland >/dev/null; then
    print_info "Reloading Hyprland config..."
    if ! hyprctl reload; then
        print_info "Note: hyprctl reload failed (might not be in Hyprland session)"
    fi
fi

print_success "Theme applied successfully!"
echo
echo "If you don't see changes:"
echo "1. Make sure you're in a Hyprland session"
echo "2. Restart AGS with: killall ags && ags"
echo "3. Reload Hyprland with: hyprctl reload"