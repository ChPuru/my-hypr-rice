#!/usr/bin/env bash

set -e

# Only stow configs that actually have content
# Based on your file listing, these are the ones with actual files

echo "=== STOWING ONLY ESSENTIAL CONFIGS ==="

# Clean up any broken symlinks first
echo "Cleaning up broken symlinks..."
for config in hypr ags ags-advanced kitty nvim; do
    if [[ -L "$HOME/.config/$config" ]]; then
        echo "Removing existing symlink: $HOME/.config/$config"
        rm "$HOME/.config/$config"
    elif [[ -d "$HOME/.config/$config" ]]; then
        echo "Warning: $HOME/.config/$config exists but is not a symlink"
        echo "Moving to backup: $HOME/.config/$config.backup"
        mv "$HOME/.config/$config" "$HOME/.config/$config.backup"
    fi
done

# Create the essential configs manually
echo "Creating essential symlinks manually..."

# 1. Hyprland config
if [[ -d "dotfiles/hypr" ]]; then
    echo "Linking Hyprland config..."
    ln -sf "$(pwd)/dotfiles/hypr" "$HOME/.config/hypr"
    echo "✓ Hyprland config linked"
else
    echo "✗ dotfiles/hypr not found"
fi

# 2. AGS config (check which one exists)
if [[ -d "dotfiles/ags-advanced" ]]; then
    echo "Linking AGS Advanced config..."
    ln -sf "$(pwd)/dotfiles/ags-advanced" "$HOME/.config/ags"
    echo "✓ AGS Advanced config linked"
elif [[ -d "dotfiles/ags" ]]; then
    echo "Linking AGS Simple config..."
    ln -sf "$(pwd)/dotfiles/ags" "$HOME/.config/ags"
    echo "✓ AGS Simple config linked"
else
    echo "✗ No AGS config found"
fi

# 3. Kitty config
if [[ -d "dotfiles/kitty" ]]; then
    echo "Linking Kitty config..."
    ln -sf "$(pwd)/dotfiles/kitty" "$HOME/.config/kitty"
    echo "✓ Kitty config linked"
else
    echo "✗ dotfiles/kitty not found"
fi

# 4. Neovim config
if [[ -d "dotfiles/nvim" ]]; then
    echo "Linking Neovim config..."
    ln -sf "$(pwd)/dotfiles/nvim" "$HOME/.config/nvim"
    echo "✓ Neovim config linked"
else
    echo "✗ dotfiles/nvim not found"
fi

# 5. Other configs that have actual content
CONFIGS_WITH_CONTENT=(
    "btop"
    "cava" 
    "fastfetch"
    "fontconfig"
    "gamemode"
    "gtk-3.0"
    "gtk-4.0"
    "hyprlock"
    "kvantum"
    "mangohud"
    "qt6ct"
    "starship"
    "tmux"
    "wofi"
    "yazi"
)

for config in "${CONFIGS_WITH_CONTENT[@]}"; do
    if [[ -d "dotfiles/$config" ]] && find "dotfiles/$config" -type f | grep -q .; then
        echo "Linking $config..."
        ln -sf "$(pwd)/dotfiles/$config" "$HOME/.config/$config"
        echo "✓ $config linked"
    else
        echo "- Skipping $config (empty or missing)"
    fi
done

# 6. Home directory configs
echo "Linking home directory configs..."
if [[ -d "dotfiles/zsh" ]]; then
    # Copy zsh files to home directory (they start with .)
    for file in dotfiles/zsh/.*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            ln -sf "$(pwd)/$file" "$HOME/$filename"
            echo "✓ Linked $filename"
        fi
    done
fi

if [[ -d "dotfiles/git" ]]; then
    # Copy git files to home directory  
    for file in dotfiles/git/.*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            ln -sf "$(pwd)/$file" "$HOME/$filename"
            echo "✓ Linked $filename"
        fi
    done
fi

# 7. Scripts directory
if [[ -d "scripts" ]]; then
    echo "Linking scripts directory..."
    ln -sf "$(pwd)/scripts" "$HOME/.config/scripts"
    echo "✓ Scripts linked"
fi

echo
echo "=== VERIFICATION ==="
echo "Checking essential symlinks:"

for config in hypr ags kitty nvim; do
    if [[ -L "$HOME/.config/$config" ]]; then
        echo "✓ $config is symlinked to: $(readlink "$HOME/.config/$config")"
    else
        echo "✗ $config is NOT symlinked"
    fi
done

echo
echo "Manual linking complete!"
echo "Next steps:"
echo "1. ./theme.sh catppuccin-mocha"
echo "2. Start/restart Hyprland session"