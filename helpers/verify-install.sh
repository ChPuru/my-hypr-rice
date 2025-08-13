#!/usr/bin/env bash

print_check() {
    local title="$1"
    local status="$2"
    if [[ "$status" == "OK" ]]; then
        gum style --foreground 10 "✔ $title"
    else
        gum style --foreground 9 "✖ $title"
        echo "  └─ $3"
    fi
}

# --- Check Packages ---
if command -v hyprctl &> /dev/null; then
    print_check "Hyprland installed" "OK"
else
    print_check "Hyprland installed" "FAIL" "Hyprland command not found."
fi

# --- Check Services ---
if systemctl is-enabled --quiet bluetooth.service; then
    print_check "Bluetooth service enabled" "OK"
else
    print_check "Bluetooth service enabled" "FAIL" "Run 'sudo systemctl enable bluetooth.service'"
fi

# --- Check Dotfiles ---
# --- MODIFICATION START ---
# We check if the DIRECTORY is a symlink, which is what stow creates.
if [[ -L "$HOME/.config/hypr" ]]; then
    print_check "Hyprland config symlinked" "OK"
else
    print_check "Hyprland config symlinked" "FAIL" "Config not found. Run the stow command from install.sh"
fi
# --- MODIFICATION END ---