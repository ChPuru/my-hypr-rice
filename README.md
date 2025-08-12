# My Hyprland Rice

A complete, themed, and automated Hyprland environment for Arch Linux. This repository contains the full configuration for a "god-tier" desktop experience, managed by scripts and Stow.

![screenshot-placeholder](https://via.placeholder.com/800x450.png?text=Your+Screenshot+Here)

---

## Features

- **Automated Installation:** A single script to install all packages and deploy configurations.
- **Dynamic Theming:** Instantly switch between themes like Catppuccin and Tokyo Night across all applications.
- **Powerful Shell:** Pre-configured Zsh with Starship, fzf, and useful aliases.
- **Custom Widgets:** A sleek and functional bar and dashboard powered by AGS.
- **Integrated Development Suite:** Full setup for Neovim, Tmux, and Lazygit.
- **Gaming Ready:** Comes with Steam, Lutris, GameMode, and MangoHud pre-configured.
- **Robust Scripting:** Custom scripts for screenshots, volume/brightness control, color picking, and more.
- **Full GUI Theming:** Consistent look and feel for both terminal and graphical applications.

## Installation

1. **Start with a clean Arch Linux install.**
2. **Clone the repository:**

    ```bash
    git clone https://github.com/ChPuru/my-hypr-rice.git
    cd my-hypr-rice
    ```

3. **Run the installer:**

    ```bash
    chmod +x install.sh
    ./install.sh
    ```

4. **Reboot** when prompted.

## Usage

### Changing Themes

To change the system-wide theme, run the `theme.sh` script with the name of a theme from the `/themes` directory.

```bash
./theme.sh tokyo-night
