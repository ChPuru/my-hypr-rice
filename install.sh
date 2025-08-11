#!/usr/bin/env bash

# Stop on first error
set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_FILE="/tmp/hypr-rice-install.log"
REAL_USER=$(logname)

# --- Helper Functions ---
print_info() { printf "\e[34m[INFO]\e[0m %s\n" "$1"; }
print_success() { printf "\e[32m[SUCCESS]\e[0m %s\n" "$1"; }
print_warning() { printf "\e[33m[WARNING]\e[0m %s\n" "$1"; }
print_error() { printf "\e[31m[ERROR]\e[0m %s\n" "$1" >&2; }

# --- Main Functions ---
command_exists() { command -v "$1" &> /dev/null; }

run_pre_install_checks() {
    print_info "Running pre-installation checks..."
    if [[ $EUID -eq 0 ]]; then print_error "This script should not be run as root."; exit 1; fi
    if ! sudo -v; then print_error "Sudo privileges are required."; exit 1; fi
    if ! ping -c 1 -W 1 archlinux.org &> /dev/null; then print_error "No internet connection."; exit 1; fi
    print_success "Pre-installation checks passed."
}

enable_multilib() {
    print_info "Enabling Multilib repository..."
    # This command is correct as-is. `sed -i` modifies the file directly
    # and does not use shell redirection, so it doesn't trigger SC2024.
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    print_success "Multilib enabled."
}

install_pacman_packages() {
    print_info "Updating package database and installing Pacman packages..."
    # CORRECTED: Use tee for logging with sudo
    sudo pacman -Syu --noconfirm --needed - <(sudo cat "$SCRIPT_DIR/packages/pacman-packages.txt") 2>&1 | sudo tee -a "$LOG_FILE" > /dev/null
    print_success "Pacman packages installed."
}

install_aur_helper() {
    if ! command_exists paru; then
        print_info "AUR helper 'paru' not found. Installing..."
        # CORRECTED: Use tee for logging with sudo
        sudo pacman -S --noconfirm --needed base-devel 2>&1 | sudo tee -a "$LOG_FILE" > /dev/null
        # This part logs as the user, which is fine.
        git clone https://aur.archlinux.org/paru.git /tmp/paru >> "$LOG_FILE" 2>&1
        (cd /tmp/paru && makepkg -si --noconfirm) >> "$LOG_FILE" 2>&1
        print_success "'paru' installed."
    else
        print_info "'paru' is already installed."
    fi
}

install_aur_packages() {
    print_info "Installing AUR packages..."
    paru -S --noconfirm --needed - < "$SCRIPT_DIR/packages/aur-packages.txt" >> "$LOG_FILE" 2>&1
    print_success "AUR packages installed."
}

setup_dotfiles() {
    print_info "Setting up dotfiles using Stow..."
    chmod +x "$SCRIPT_DIR/stow.sh"
    "$SCRIPT_DIR/stow.sh" >> "$LOG_FILE" 2>&1
    print_success "Dotfiles stowed."
}

setup_system_configs() {
    print_info "Setting up system-level configurations..."
    if [ -f /etc/tlp.conf ]; then
        sudo mv /etc/tlp.conf /etc/tlp.conf.bak
    fi
    sudo cp "$HOME/.config/tlp/tlp.conf" /etc/tlp.conf
    print_success "System configs deployed."
}

make_scripts_executable() {
    print_info "Making custom scripts executable..."
    chmod +x "$HOME/.config/scripts/"*
    print_success "Scripts are now executable."
}

apply_initial_theme() {
    print_info "Applying initial theme (catppuccin-mocha)..."
    chmod +x "$SCRIPT_DIR/theme.sh"
    "$SCRIPT_DIR/theme.sh" catppuccin-mocha >> "$LOG_FILE" 2>&1
    print_success "Initial theme applied."
}

setup_zsh() {
    print_info "Setting up Zsh as the default shell..."
    if [[ "$SHELL" != "/bin/zsh" ]]; then
        # CORRECTED: Use tee for logging with sudo
        sudo chsh -s /bin/zsh "$REAL_USER" 2>&1 | sudo tee -a "$LOG_FILE" > /dev/null
        print_success "Default shell changed to Zsh."
    else
        print_info "Zsh is already the default shell."
    fi
}

enable_services() {
    print_info "Enabling systemd services..."
    # CORRECTED: Use tee for logging with sudo
    sudo systemctl enable ly.service 2>&1 | sudo tee -a "$LOG_FILE" > /dev/null
    sudo systemctl enable bluetooth.service 2>&1 | sudo tee -a "$LOG_FILE" > /dev/null
    sudo systemctl enable gamemoded 2>&1 | sudo tee -a "$LOG_FILE" > /dev/null
    sudo systemctl enable tlp.service 2>&1 | sudo tee -a "$LOG_FILE" > /dev/null
    print_success "Systemd services enabled."
}

# --- Main Execution ---
main() {
    # This creates the log file as the user, giving them ownership.
    true > "$LOG_FILE"
    
    run_pre_install_checks
    print_warning "This script will install packages and configure your system."
    
    # CORRECTED: Use read -r
    read -r -p "Do you want to proceed? (y/N): " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then print_error "Installation aborted."; exit 0; fi

    enable_multilib
    install_pacman_packages
    install_aur_helper
    install_aur_packages
    setup_dotfiles
    setup_system_configs
    make_scripts_executable
    apply_initial_theme
    setup_zsh
    enable_services

    print_success "Project Complete! Your Hyprland rice is fully installed."
    print_warning "IMPORTANT: Edit ~/.config/kanshi/config with your monitor names to enable multi-monitor support."
    print_info "It is highly recommended to reboot your system now."
    
    # CORRECTED: Use read -r
    read -r -p "Reboot now? (y/N): " reboot_choice
    if [[ "$reboot_choice" == "y" || "$reboot_choice" == "Y" ]]; then sudo reboot; fi
}

main