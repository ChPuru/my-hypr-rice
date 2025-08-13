#!/usr/bin/env bash

# Hyprland Rice Diagnostics Script
# This script checks common issues with the rice installation

echo "=== HYPRLAND RICE DIAGNOSTICS ==="
echo

# Check if we're in Hyprland
echo "1. Checking Hyprland Session:"
if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]] || pgrep -x Hyprland >/dev/null; then
    echo "✓ Hyprland is running"
else
    echo "✗ Hyprland is NOT running"
    echo "  → You need to start Hyprland session first"
fi
echo

# Check stow symlinks
echo "2. Checking Stow Symlinks:"
if [[ -L "$HOME/.config/hypr" ]]; then
    echo "✓ Hyprland config is symlinked"
    echo "  → Points to: $(readlink "$HOME/.config/hypr")"
else
    echo "✗ Hyprland config is NOT symlinked"
    if [[ -d "$HOME/.config/hypr" ]]; then
        echo "  → Directory exists but is not a symlink"
        echo "  → This means stow didn't work properly"
    else
        echo "  → Directory doesn't exist at all"
    fi
fi

if [[ -L "$HOME/.config/ags" ]]; then
    echo "✓ AGS config is symlinked"
else
    echo "✗ AGS config is NOT symlinked"
fi

if [[ -L "$HOME/.config/kitty" ]]; then
    echo "✓ Kitty config is symlinked"
else
    echo "✗ Kitty config is NOT symlinked"
fi
echo

# Check if template files were processed
echo "3. Checking Template Processing:"
if [[ -f "$HOME/.config/hypr/hyprland.conf" ]]; then
    if grep -q "##.*##" "$HOME/.config/hypr/hyprland.conf"; then
        echo "✗ Template placeholders still exist in hyprland.conf"
        echo "  → Theme script didn't run or failed"
    else
        echo "✓ Hyprland config processed (no template placeholders)"
    fi
else
    echo "✗ hyprland.conf not found"
fi
echo

# Check running processes
echo "4. Checking Key Processes:"
processes=("ags" "swww" "swaync" "hyprpaper")
for proc in "${processes[@]}"; do
    if pgrep -x "$proc" >/dev/null; then
        echo "✓ $proc is running"
    else
        echo "✗ $proc is NOT running"
    fi
done
echo

# Check theme files
echo "5. Checking Theme Files:"
if [[ -f "$(pwd)/themes/catppuccin-mocha.json" ]]; then
    echo "✓ Theme files exist"
else
    echo "✗ Theme files missing"
fi
echo

# Check for common config issues
echo "6. Checking Config Issues:"
if [[ -f "$HOME/.config/hypr/hyprland.conf" ]]; then
    if grep -q "exec-once.*ags" "$HOME/.config/hypr/hyprland.conf"; then
        echo "✓ AGS autostart configured"
    else
        echo "✗ AGS autostart NOT configured"
    fi
    
    if grep -q "source.*keybinds.conf" "$HOME/.config/hypr/hyprland.conf"; then
        echo "✓ Keybinds sourced"
    else
        echo "✗ Keybinds NOT sourced"
    fi
else
    echo "✗ Cannot check config - file missing"
fi
echo

# Suggest fixes
echo "=== SUGGESTED FIXES ==="
echo

if [[ "$XDG_CURRENT_DESKTOP" != "Hyprland" ]] && ! pgrep -x Hyprland >/dev/null; then
    echo "CRITICAL: Start Hyprland session first:"
    echo "  → Log out and select Hyprland from your display manager"
    echo "  → Or run 'Hyprland' from a TTY"
    echo
fi

if [[ ! -L "$HOME/.config/hypr" ]]; then
    echo "FIX 1: Re-run stow process:"
    echo "  cd $(pwd)"
    echo "  ./stow.sh"
    echo
fi

if [[ -f "$HOME/.config/hypr/hyprland.conf" ]] && grep -q "##.*##" "$HOME/.config/hypr/hyprland.conf"; then
    echo "FIX 2: Run theme script:"
    echo "  cd $(pwd)"
    echo "  ./theme.sh catppuccin-mocha"
    echo
fi

if ! pgrep -x ags >/dev/null; then
    echo "FIX 3: Start AGS manually:"
    echo "  ags"
    echo
fi

echo "FIX 4: Complete reset (if all else fails):"
echo "  cd $(pwd)"
echo "  ./unstow.sh      # Remove old symlinks"
echo "  ./stow.sh        # Re-create symlinks"
echo "  ./theme.sh catppuccin-mocha  # Apply theme"
echo "  hyprctl reload   # Reload Hyprland config"
echo

echo "=== END DIAGNOSTICS ==="