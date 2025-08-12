# My Hypr-Rice: A Dynamic & Themed Hyprland Framework

![Showcase](docs/showcase.png)
*(Note: You will need to add a screenshot named `showcase.png` to the `docs` folder for this to display)*

A complete, beautifully themed, and highly automated Hyprland setup designed for both aesthetics and productivity. This repository is more than just a collection of dotfiles; it's a full framework for creating, managing, and enjoying a dynamic desktop experience.

---

## ✨ Features

* **Dynamic Theming Engine**: Switch between curated themes instantly or generate a new theme from any wallpaper using `pywal`. All components, from the terminal to the lock screen, are themed automatically.

* **Stunning Visuals**: A beautiful and functional AGS setup featuring an advanced dashboard, a slide-out control center, interactive on-screen-displays (OSDs) for volume/brightness, and a personalized lock screen.

* **Intelligent Installer**: An interactive installer that detects your hardware (like NVIDIA GPUs), asks about your setup (Laptop/Desktop), and configures the system accordingly.

* **TUI Rice Manager**: A user-friendly terminal menu (`rice-manager.sh`) to control your entire setup—switch themes, update the rice from GitHub, and verify the installation.

* **Productivity Focused**: Comes with a pre-configured Neovim setup using `lazy.nvim`, a themed tmux environment, and integrated `lazygit` for a seamless development workflow.

* **Gaming Ready**: Includes configurations for Steam, Lutris, MangoHud, and GameMode for an optimized gaming experience, right out of the box.

* **Unified Shell Experience**: All components, from the bar to the control center, are designed to work together as a single, cohesive unit.

---

## 🚀 Installation

> **Warning:** This script is designed to be run on a clean Arch Linux installation. Running it on a pre-configured system may cause conflicts. Please back up your existing dotfiles before proceeding.

1. **Clone the repository:**

    ```bash
    git clone https://github.com/ChPuru/my-hypr-rice.git
    cd my-hypr-rice
    ```

2. **Install `gum` (required for the installer's UI):**

    ```bash
    sudo pacman -Syu gum
    ```

3. **Make the scripts executable:**

    ```bash
    chmod +x install.sh rice-manager.sh scripts/*.sh helpers/*.sh
    ```

4. **Run the installer:**

    ```bash
    ./install.sh
    ```

    The script is interactive and will guide you through the process. After it completes, reboot your system to finalize the setup.

---

## 💡 Post-Installation Usage

After rebooting, you can manage your entire rice using the TUI manager:

```bash
./rice-manager.sh
