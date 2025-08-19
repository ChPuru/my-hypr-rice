#!/usr/bin/env bash

set -e

# Simple theme script that doesn't rely on jq
# Uses hardcoded Catppuccin Mocha colors

print_info() { printf "\e[34m[INFO]\e[0m %s\n" "$1"; }
print_success() { printf "\e[32m[SUCCESS]\e[0m %s\n" "$1"; }
print_error() { printf "\e[31m[ERROR]\e[0m %s\n" "$1"; }

# Hardcoded Catppuccin Mocha theme (since JSON is causing issues)
declare -A THEME_COLORS=(
    ["wallpaper"]="/home/puru/Pictures/wallpapers/catppuccin-mocha.png"
    ["font_main"]="JetBrainsMono Nerd Font"
    ["font_size"]="11"
    ["lockscreen_image"]="/home/puru/.config/hypr/assets/lock-image.png" 
    ["lockscreen_welcome_text"]="Welcome back!"
    ["nvim_theme"]="catppuccin"
    ["gtk_theme"]="Catppuccin-Mocha-Standard-Blue-dark"
    ["kvantum_theme"]="Catppuccin-Mocha"
    ["icon_theme"]="Papirus-Dark"
    ["cursor_theme"]="Bibata-Modern-Classic"
    ["background"]="1e1e2e"
    ["foreground"]="cdd6f4"
    ["text"]="cdd6f4"
    ["black"]="45475a"
    ["gray"]="585b70"
    ["red"]="f38ba8"
    ["green"]="a6e3a1"
    ["yellow"]="f9e2af"
    ["blue"]="89b4fa"
    ["magenta"]="f5c2e7"
    ["cyan"]="89dceb"
    ["white"]="bac2de"
    ["mauve"]="cba6f7"
    ["sky"]="89dceb"
    ["crust"]="11111b"
    ["mantle"]="181825"
    ["surface0"]="313244"
    ["surface1"]="45475a"
    ["surface2"]="585b70"
    ["subtext1"]="bac2de"
    ["overlay0"]="6c7086"
    ["overlay1"]="7f849c"
    ["overlay2"]="9399b2"
    ["base"]="1e1e2e"
    ["rosewater"]="f5e0dc"
    ["flamingo"]="f2cdcd"
    ["pink"]="f5c2e7"
    ["maroon"]="eba0ac"
    ["peach"]="fab387"
    ["teal"]="94e2d5"
    ["lavender"]="b4befe"
    ["subtext0"]="a6adc8"
    ["hud_foreground"]="cdd6f4"
    ["hud_background"]="1e1e2e"
    ["hud_accent"]="89b4fa"
)

apply_theme() {
    print_info "Applying Catppuccin Mocha theme..."
    
    # Find all template files and process them
    local template_count=0
    local processed_count=0
    
    while IFS= read -r -d '' template_file; do
        ((template_count++))
        local destination_file="${template_file%.tmpl}"
        local temp_file
        temp_file=$(mktemp)

        
        print_info "Processing: $(basename "$template_file")"
        
        # Start with the template content
        cp "$template_file" "$temp_file"
        
        # Replace each placeholder
        for key in "${!THEME_COLORS[@]}"; do
            local value="${THEME_COLORS[$key]}"
            # Escape special characters for sed
            value=$(printf '%s\n' "$value" | sed "s/[[\.*^$()+?{|]/\\&/g")
            sed -i "s|##${key}##|${value}|g" "$temp_file"
        done
        
        # Move processed file to destination
        if mv "$temp_file" "$destination_file"; then
            print_success "✓ Generated: $(basename "$destination_file")"
            ((processed_count++))
        else
            print_error "✗ Failed to process: $(basename "$template_file")"
            rm -f "$temp_file"
        fi
        
    done < <(find "$HOME/.config" -name "*.tmpl" -type f -print0)
    
    print_info "Processed $processed_count of $template_count template files"
    
    # Special handling for Neovim
    local nvim_file="$HOME/.config/nvim/lua/plugins/colorscheme.lua"
    if [[ -f "$nvim_file" ]]; then
        sed -i 's/vim\.g\.nvim_theme = .*/vim.g.nvim_theme = "catppuccin"/' "$nvim_file"
        print_success "✓ Updated Neovim theme"
    fi
    
    print_success "Theme processing completed!"
}

# Create assets directory and placeholder image if needed
create_assets() {
    local assets_dir="$HOME/.config/hypr/assets"
    mkdir -p "$assets_dir"
    
    if [[ ! -f "$assets_dir/lock-image.png" ]]; then
        print_info "Creating placeholder lock image..."
        # Create a simple colored circle as placeholder
        if command -v convert >/dev/null 2>&1; then
            convert -size 150x150 xc:none -fill "#89b4fa" -draw "circle 75,75 75,0" "$assets_dir/lock-image.png"
            print_success "✓ Created placeholder lock image"
        else
            print_info "ImageMagick not available, creating text placeholder"
            echo "Placeholder for lock screen image" > "$assets_dir/lock-image.png"
        fi
    fi
}

# Main execution
main() {
    print_info "Starting simple theme application..."
    
    create_assets
    apply_theme
    
    # Try to reload services if available
    if command -v hyprctl >/dev/null 2>&1 && pgrep -x Hyprland >/dev/null; then
        print_info "Reloading Hyprland..."
        hyprctl reload || print_info "Note: Could not reload Hyprland (might not be in session)"
    fi
    
    if pgrep -x ags >/dev/null; then
        print_info "Restarting AGS..."
        killall ags || true
        sleep 1
        ags &
        print_success "✓ AGS restarted"
    else
        print_info "AGS not running - start it manually with: ags"
    fi
    
    print_success "Theme applied! If you're in Hyprland, you should see changes now."
    print_info "If not, try: killall ags && ags"
}

main