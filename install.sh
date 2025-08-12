#!/usr/bin/env bash

# Stop on first error
set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_FILE="/tmp/hypr-rice-install.log"

# Find the real user even when run with sudo - declare and assign separately
REAL_USER=""
if [[ -n "$SUDO_USER" ]]; then
    REAL_USER="$SUDO_USER"
else
    REAL_USER=$(whoami)
fi

HOME_DIR=""
HOME_DIR=$(getent passwd "$REAL_USER" | cut -d: -f6)

# --- Exported variables for other functions ---
export INSTALL_NVIDIA="false"
export INSTALL_LAPTOP_TOOLS="false"
export AGS_CHOICE="Simple"

# --- Helper Functions ---
print_info() { gum style --foreground 33 "[INFO]" " $1"; }
print_success() { gum style --foreground 10 "[SUCCESS]" " $1"; }
print_warning() { gum style --foreground 214 "[WARNING]" " $1"; }
print_error() { gum style --foreground 9 "[ERROR]" " $1" >&2; }

# --- Main Functions ---
command_exists() { command -v "$1" &> /dev/null; }

run_pre_install_checks() {
    print_info "Running pre-installation checks..."
    if [[ $EUID -eq 0 ]]; then print_error "This script should not be run as root. It will ask for sudo when needed."; exit 1; fi
    if ! command_exists sudo; then print_error "'sudo' command not found. Please install it first."; exit 1; fi
    if ! sudo -v; then print_error "Sudo privileges are required."; exit 1; fi
    if ! ping -c 1 -W 1 archlinux.org &> /dev/null; then print_error "No internet connection."; exit 1; fi
    if ! command_exists gum; then print_error "'gum' is not installed. Please install it first (sudo pacman -S gum)."; exit 1; fi
    print_success "Pre-installation checks passed."
}

ask_questions() {
    gum style --border normal --margin "1" --padding "1" --border-foreground 212 "Welcome to the Hypr-Rice Installer!"

    AGS_CHOICE=$(gum choose "Simple (A clean, basic bar)" "Advanced (Feature-rich dashboard & OSDs)")

    if lspci | grep -E "NVIDIA|GeForce"; then
        if gum confirm "NVIDIA GPU detected. Would you like to install NVIDIA proprietary drivers?"; then
            INSTALL_NVIDIA="true"
        fi
    fi

    local laptop_choice
    laptop_choice=$(gum choose "Desktop" "Laptop")
    if [[ "$laptop_choice" == "Laptop" ]]; then
        INSTALL_LAPTOP_TOOLS="true"
    fi
}

enable_multilib() {
    print_info "Enabling Multilib repository for Steam & Wine..."
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    print_success "Multilib enabled."
}

install_pacman_packages() {
    print_info "Updating package database and installing packages..."
    
    {
        # Combine core and full packages into one stream for installation
        cat "$SCRIPT_DIR/packages/pacman-core.txt" "$SCRIPT_DIR/packages/pacman-full.txt" | sudo pacman -Syu --noconfirm --needed -
        
        if [[ "$INSTALL_NVIDIA" == "true" ]]; then
            print_info "Installing NVIDIA drivers..."
            sudo pacman -S --noconfirm --needed nvidia-dkms nvidia-utils lib32-nvidia-utils
        fi
        
        if [[ "$INSTALL_LAPTOP_TOOLS" == "true" ]]; then
            print_info "Installing laptop tools (tlp)..."
            sudo pacman -S --noconfirm --needed tlp
        fi
    } >> "$LOG_FILE" 2>&1

    print_success "All Pacman packages installed."
}

install_aur_helper() {
    if ! command_exists paru; then
        print_info "AUR helper 'paru' not found. Installing..."
        # --- MODIFICATION START ---
        # Grouped commands to redirect output once, per shellcheck SC2129
        {
            sudo pacman -S --noconfirm --needed base-devel
            git clone https://aur.archlinux.org/paru.git /tmp/paru
            (cd /tmp/paru && makepkg -si --noconfirm)
        } >> "$LOG_FILE" 2>&1
        # --- MODIFICATION END ---
        print_success "'paru' installed."
    else
        print_info "'paru' is already installed."
    fi
}

install_aur_packages() {
    print_info "Installing AUR packages..."
    { paru -S --noconfirm --needed - < "$SCRIPT_DIR/packages/aur-packages.txt"; } >> "$LOG_FILE" 2>&1
    print_success "AUR packages installed."
}

setup_dotfiles() {
    print_info "Setting up dotfiles using Stow..."
    chmod +x "$SCRIPT_DIR/stow.sh"
    
    # This command stows all directories inside 'dotfiles' except for the AGS config that was NOT chosen.
    if [[ "$AGS_CHOICE" == "Advanced (Feature-rich dashboard & OSDs)" ]]; then
        print_info "Stowing Advanced AGS config and all other dotfiles..."
        { find "$SCRIPT_DIR/dotfiles" -maxdepth 1 -mindepth 1 -type d ! -name "ags" -exec stow -v -R -t "$HOME_DIR" --dir="$SCRIPT_DIR/dotfiles" {} +; } >> "$LOG_FILE" 2>&1
    else
        print_info "Stowing Simple AGS config and all other dotfiles..."
        { find "$SCRIPT_DIR/dotfiles" -maxdepth 1 -mindepth 1 -type d ! -name "ags-advanced" -exec stow -v -R -t "$HOME_DIR" --dir="$SCRIPT_DIR/dotfiles" {} +; } >> "$LOG_FILE" 2>&1
    fi

    print_success "Dotfiles stowed."
}

apply_initial_theme() {
    print_info "Applying initial theme (catppuccin-mocha)..."
    chmod +x "$SCRIPT_DIR/theme.sh"
    { "$SCRIPT_DIR/theme.sh" catppuccin-mocha; } >> "$LOG_FILE" 2>&1
    print_success "Initial theme applied."
}

setup_zsh() {
    print_info "Setting up Zsh as the default shell for $REAL_USER..."
    local current_shell
    current_shell=$(getent passwd "$REAL_USER" | cut -d: -f7)
    if [[ "$current_shell" != "/bin/zsh" ]]; then
        { sudo chsh -s /bin/zsh "$REAL_USER"; } >> "$LOG_FILE" 2>&1
        print_success "Default shell changed to Zsh."
    else
        print_info "Zsh is already the default shell."
    fi
}

enable_services() {
    print_info "Enabling systemd services..."
    {
        sudo systemctl enable ly.service
        sudo systemctl enable bluetooth.service
        sudo systemctl enable gamemoded
        if [[ "$INSTALL_LAPTOP_TOOLS" == "true" ]]; then
            sudo systemctl enable tlp.service
        fi
    } >> "$LOG_FILE" 2>&1
    print_success "Systemd services enabled."
}

# --- Main Execution ---
main() {
    # Clear log file for a fresh run
    true > "$LOG_FILE"

    run_pre_install_checks
    ask_questions

    if ! gum confirm "Ready to start the installation? This will install packages and configure your system."; then
        print_error "Installation aborted by user."
        exit 0
    fi

    # --- Installation Steps ---
    gum spin --spinner dot --title "Enabling multilib..." -- bash -c "enable_multilib"
    gum spin --spinner dot --title "Installing Pacman packages..." -- bash -c "install_pacman_packages"
    gum spin --spinner dot --title "Installing AUR helper (paru)..." -- bash -c "install_aur_helper"
    # Run paru as the real user
    gum spin --spinner dot --title "Installing AUR packages..." -- sudo -u "$REAL_USER" bash -c "install_aur_packages"
    gum spin --spinner dot --title "Stowing dotfiles..." -- bash -c "setup_dotfiles"
    gum spin --spinner dot --title "Applying initial theme..." -- bash -c "apply_initial_theme"
    gum spin --spinner dot --title "Setting up Zsh..." -- bash -c "setup_zsh"
    gum spin --spinner dot --title "Enabling systemd services..." -- bash -c "enable_services"

    print_success "Installation complete!"
    print_info "A log file is available at $LOG_FILE"
    
    if gum confirm "It is highly recommended to reboot now. Reboot?"; then
        sudo reboot
    fi
}

# Run main function, passing all arguments to it
main "$@"