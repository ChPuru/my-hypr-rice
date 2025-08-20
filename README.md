# My Hypr-Rice: A Curated Manual Build for Hyprland

![Showcase](docs/showcase.png)

A complete, meticulously themed, and highly functional Hyprland setup built entirely by hand. After frustrating experiences with complex automation, this repository represents a return to first principles: a stable, understandable, and beautiful desktop where every component is placed with purpose.

This is not a framework with scripts; it is a **blueprint**. It provides the exact, verified configuration files needed to build a state-of-the-art desktop from a clean Arch Linux installation.

---

## ✨ Features & Curated Stack

This setup is built on a curated selection of best-in-class tools to ensure a cohesive and stable experience.

* **Desktop Core:** Hyprland (Compositor), Waybar (Status Bar), Wofi (Launcher), Kitty (Terminal), Mako (Notifications), Hyprlock (Lock Screen), Wlogout (Logout Menu).
* **Aesthetic Cohesion:** A deep, system-wide **Catppuccin Mocha** theme that covers everything from the terminal and GUI apps to the gaming overlay and web browser.
* **Power User Workflow:** Zsh with a beautiful Starship prompt, Thunar for GUI file management, and Yazi for a fast, modern terminal file manager.
* **Productivity Suite:** A pre-configured Neovim setup using `lazy.nvim` for a powerful, keyboard-driven development experience.
* **Gaming Ready:** A complete gaming stack with Steam, Lutris, GameMode for performance optimization, and a themed MangoHud overlay.
* **Visual Polish:** Spectacular window animations powered by `burn-my-windows-git`.

---

## 🚀 Manual Installation Guide

This is a manual build. You are in complete control.

**Prerequisites:** A clean Arch Linux installation with a `sudo` user and internet.

### **Part 1: Core Desktop**

1. **Install Packages:**

    ```bash
    sudo pacman -Syu --noconfirm --needed hyprland kitty waybar wofi mako swww nano git noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd catppuccin-gtk-theme-mocha papirus-icon-theme thunar blueman pavucontrol
    ```

2. **Clone this repository:**

    ```bash
    git clone https://github.com/ChPuru/my-hypr-rice.git
    ```

3. **Copy Configurations:** Manually copy the contents of the `.config` directory from this repository into your `~/.config` directory.
4. **Set Wallpaper:** Ensure the wallpaper path in `~/.config/hypr/hyprland.conf` points to a valid image.
5. **Launch:** From the TTY, type `Hyprland`.

---

## 🔑 Core Keybinds

| Keybind | Action |
| :--- | :--- |
| `Super + Return` | Open Terminal (Kitty) |
| `Super + D` | Application Launcher (Wofi) |
| `Super + E` | File Manager (Thunar) |
| `Super + T` | Terminal File Manager (Yazi) |
| `Super + L` | Lock Screen (Hyprlock) |
| `Super + Shift + E` | Logout Menu (Wlogout) |
| `Super + Q` | Close Active Window |
| `Super + N` | Open Text Editor (Neovim) |

---

## 🙏 Credits & Inspiration

This project was built by hand, but stands on the shoulders of giants. A huge thank you to the creators of these incredible repositories for their inspiration and for showcasing what is possible.

* [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
* [prasanthrangan/hyprdots](https://github.com/prasanthrangan/hyprdots)
* [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots)
* [Pahasara/HyprDots](https://github.com/Pahasara/HyprDots)
