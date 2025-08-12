#!/usr/bin/env bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Check for gum
if ! command -v gum &> /dev/null; then
    echo "Error: gum is not installed. Please install it to use this manager."
    exit 1
fi

# --- Main Menu ---
while true; do
    gum style --border normal --margin "1" --padding "1" --border-foreground 212 "Welcome to the Hypr-Rice Manager!"

    CHOICE=$(gum choose "🎨 Switch Theme" "🔄 Update Rice" "✅ Verify Installation" "🚪 Exit")

    case "$CHOICE" in
        "🎨 Switch Theme")
            THEME_CHOICE=$(gum choose "Select Pre-made Theme" "Generate from Wallpaper")
            if [[ "$THEME_CHOICE" == "Select Pre-made Theme" ]]; then
                SELECTED_THEME=$(find "$SCRIPT_DIR/themes" -name "*.json" -printf "%f\n" | sed 's/\.json//' | gum choose)
                if [[ -n "$SELECTED_THEME" ]]; then
                    "$SCRIPT_DIR/theme.sh" "$SELECTED_THEME"
                fi
            else
                WALLPAPER=$(gum file)
                if [[ -n "$WALLPAPER" ]]; then
                    "$SCRIPT_DIR/theme.sh" --from-wallpaper "$WALLPAPER"
                fi
            fi
            ;;

        "🔄 Update Rice")
            gum spin --spinner dot --title "Pulling latest changes from GitHub..." -- git pull
            gum confirm "Run the installer to apply updates?" && "$SCRIPT_DIR/install.sh"
            ;;

        "✅ Verify Installation")
            chmod +x "$SCRIPT_DIR/helpers/verify-install.sh"
            "$SCRIPT_DIR/helpers/verify-install.sh"
            gum input --placeholder "Press Enter to return to menu..."
            ;;

        "🚪 Exit")
            gum style "Goodbye!"
            exit 0
            ;;
    esac
done