#!/usr/bin/env bash

# Stop on first error
set -e

# --- Globals ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_FILE="/tmp/hypr-rice-install.log"
REAL_USER="${SUDO_USER:-$(whoami)}"
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
    if [[ $EUID -eq 0 ]]; then print_error "This script should not be run as root."; exit 1; fi
    if ! command_exists sudo; then print_error "'sudo' command not found."; exit 1; fi
    if ! sudo -v; then print_error "Sudo privileges are required."; exit 1; fi
    if ! ping -c 1 -W 1 archlinux.org &> /dev/null; then print_error "No internet connection."; exit 1; fi
    if ! command_exists gum; then print_error "'gum' is not installed."; exit 1; fi
    print_success "Pre-installation checks passed."
}

ask_questions() {
    gum style --border normal --margin "1" --padding "1" --border-foreground 212 "Welcome!"
    AGS_CHOICE=$(gum choose "Simple (A clean, basic bar)" "Advanced (Feature-rich dashboard & OSDs)")
    if lspci | grep -E "NVIDIA|GeForce"; then
        if gum confirm "NVIDIA GPU detected. Install drivers?"; then INSTALL_NVIDIA="true"; fi
    fi
    
    # --- MODIFICATION START (Fix for SC2155) ---
    local laptop_choice
    laptop_choice=$(gum choose "Desktop" "Laptop")
    # --- MODIFICATION END ---
    
    if [[ "$laptop_choice" == "Laptop" ]]; then INSTALL_LAPTOP_TOOLS="true"; fi
}

enable_multilib() {
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf 2>&1 | tee -a "$LOG_FILE"
}

install_pacman_packages() {
    cat "$SCRIPT_DIR/packages/pacman-core.txt" "$SCRIPT_DIR/packages/pacman-full.txt" | sudo pacman -Syu --noconfirm --needed - 2>&1 | tee -a "$LOG_FILE"
    if [[ "$INSTALL_NVIDIA" == "true" ]]; then
        print_info "Installing NVIDIA drivers..."
        sudo pacman -S --noconfirm --needed nvidia-dkms nvidia-utils lib32-nvidia-utils 2>&1 | tee -a "$LOG_FILE"
    fi
    if [[ "$INSTALL_LAPTOP_TOOLS" == "true" ]]; then
        print_info "Installing laptop tools (tlp)..."
        sudo pacman -S --noconfirm --needed tlp 2>&1 | tee -a "$LOG_FILE"
    fi
}

install_aur_helper() {
    if ! command_exists paru; then
        print_info "AUR helper 'paru' not found. Installing..."
        sudo pacman -S --noconfirm --needed base-devel 2>&1 | tee -a "$LOG_FILE"
        rm -rf /tmp/paru
        local retries=3
        while [ $retries -gt 0 ]; do
            if git clone https://aur.archlinux.org/paru.git /tmp/paru; then break; fi
            retries=$((retries - 1)); print_warning "git clone failed. Retrying... ($retries retries left)"; sleep 5
        done
        if [ $retries -eq 0 ]; then print_error "Failed to clone paru repository."; exit 1; fi
        (cd /tmp/paru && makepkg -si --noconfirm) 2>&1 | tee -a "$LOG_FILE"
    else
        print_info "'paru' is already installed."
    fi
}

install_aur_packages() {
    paru -S --noconfirm --needed - < "$SCRIPT_DIR/packages/aur-packages.txt" 2>&1 | tee -a "$LOG_FILE"
}

setup_dotfiles() {
    chmod +x "$SCRIPT_DIR/stow.sh"
    if [[ "$AGS_CHOICE" == "Advanced (Feature-rich dashboard & OSDs)" ]]; then
        print_info "Stowing Advanced AGS config..."
        find "$SCRIPT_DIR/dotfiles" -maxdepth 1 -mindepth 1 -type d ! -name "ags" -exec stow -v -R -t "$HOME_DIR" --dir="$SCRIPT_DIR/dotfiles" {} + 2>&1 | tee -a "$LOG_FILE"
    else
        print_info "Stowing Simple AGS config..."
        find "$SCRIPT_DIR/dotfiles" -maxdepth 1 -mindepth 1 -type d ! -name "ags-advanced" -exec stow -v -R -t "$HOME_DIR" --dir="$SCRIPT_DIR/dotfiles" {} + 2>&1 | tee -a "$LOG_FILE"
    fi
}

apply_initial_theme() {
    chmod +x "$SCRIPT_DIR/theme.sh"
    "$SCRIPT_DIR/theme.sh" catppuccuccin-mocha 2>&1 | tee -a "$LOG_FILE"
}

setup_zsh() {
    if [[ "$(getent passwd "$REAL_USER" | cut -d: -f7)" != "/bin/zsh" ]]; then
        sudo chsh -s /bin/zsh "$REAL_USER" 2>&1 | tee -a "$LOG_FILE"
    else
        print_info "Zsh is already the default shell."
    fi
}

enable_services() {
    {
        sudo systemctl enable ly.service
        sudo systemctl enable bluetooth.service
        sudo systemctl enable gamemoded
        if [[ "$INSTALL_LAPTOP_TOOLS" == "true" ]]; then sudo systemctl enable tlp.service; fi
    } 2>&1 | tee -a "$LOG_FILE"
}

# --- Main Execution ---
main() {
    true > "$LOG_FILE"
    run_pre_install_checks
    ask_questions
    if ! gum confirm "Ready to start the installation?"; then print_error "Installation aborted."; exit 0; fi
    sudo -v
    print_info "--- Starting Installation ---"

    print_info "Step 1: Enabling multilib..."
    enable_multilib; print_success "Multilib enabled."

    print_info "Step 2: Installing Pacman packages..."
    install_pacman_packages; print_success "Pacman packages installed."

    print_info "Step 3: Installing AUR helper (paru)..."
    install_aur_helper; print_success "AUR helper installed."

    print_info "Step 4: Installing AUR packages..."
    # --- MODIFICATION START (Fix for SC2024 and simplification) ---
    # We are already the correct user, so we can call the function directly.
    install_aur_packages
    # --- MODIFICATION END ---
    print_success "AUR packages installed."

    print_info "Step 5: Stowing dotfiles..."
    setup_dotfiles; print_success "Dotfiles stowed."

    print_info "Step 6: Applying initial theme..."
    apply_initial_theme; print_success "Initial theme applied."

    print_info "Step 7: Setting up Zsh..."
    setup_zsh; print_success "Zsh setup complete."

    print_info "Step 8: Enabling systemd services..."
    enable_services; print_success "Systemd services enabled."

    print_success "--- Installation Complete! ---"
    if gum confirm "Reboot now?"; then sudo reboot; fi
}

main