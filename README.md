# My Mocha Hyprland - A Catppuccin-Themed Desktop
---

## ᓚᘏᗢ About This Rice

This repository contains the complete configuration files for my performance-oriented and aesthetically pleasing Hyprland desktop environment. The entire setup is themed with the beautiful **Catppuccin Mocha** palette, designed to be both functional for development and beautiful for daily use.

This configuration is built from the ground up to be fast, responsive, and highly customizable, using a modern Wayland-native software stack.

---

## ✨ Features

- **Stunning Visuals:** A cohesive Catppuccin Mocha theme across all applications, managed by `wallust`.
- **Dynamic Theming:** Change your wallpaper and the entire system color scheme on the fly.
- **Fast & Lightweight:** Uses the Zinit plugin manager for near-instantaneous terminal startup.
- **Smooth Animations:** Fluid window animations and effects powered by Hyprland.
- **Powerful Terminal:** A pre-configured Kitty terminal with a custom Zsh prompt, syntax highlighting, and auto-suggestions.
- **Functional Bar & Widgets:** A clean and informative Waybar setup, with interactive widgets for music, system stats, and more.
- **Integrated Tools:** Includes configurations for Rofi, SwayNC, Neovim, and many other essential tools.

---

## 📋 Core Components

| Category              | Application                                                              |
| --------------------- | ------------------------------------------------------------------------ |
| **Window Manager**    | [Hyprland](https://hyprland.org/) (Wayland Compositor)                   |
| **Login Manager**     | [SDDM](https://github.com/sddm/sddm) with Catppuccin Theme                 |
| **Shell & Terminal**  | [Zsh](https://www.zsh.org/) + [Zinit](https://github.com/zdharma-continuum/zinit) & [Kitty](https://sw.kovidgoyal.net/kitty/) |
| **Bar & Launcher**    | [Waybar](https://github.com/Alexays/Waybar) & [Rofi](https://github.com/davatorium/rofi) |
| **Theming Engine**    | [Wallust](https://github.com/wallust-rs/wallust) & [swww](https://github.com/Horus645/swww) |
| **Notification Daemon** | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)           |
| **File Manager**      | [Thunar](https://docs.xfce.org/xfce/thunar/start) & [Yazi](https://github.com/sxyazi/yazi) (Terminal) |
| **Text Editor**       | [Neovim](https://neovim.io/) (with a custom configuration)                 |

---

## 🚀 Installation Guide

**Disclaimer:** These dotfiles are configured for my personal setup on an Arch-based Linux distribution. You may need to adapt scripts and configurations for your own hardware and workflow.

### 1. Prerequisites

- An **Arch-based Linux distribution** (e.g., Arch Linux, EndeavourOS) is highly recommended.
- An AUR helper like `yay` is required for some packages.
- `git` must be installed.

### 2. Clone the Repository

```bash
git clone https://github.com/ChPuru/my-hypr-rice.git ~/.config/hypr
cd ~/.config/hypr
```

### 3. Install Dependencies

The following commands will install all the necessary packages from the official repositories and the AUR.

<details>
<summary><strong>Click to expand and see the installation commands</strong></summary>

#### From Official Repositories (pacman):

```bash
sudo pacman -S --needed \
hyprland hyprcursor hypridle hyprlock sddm \
xdg-desktop-portal-hyprland waybar rofi swaync kitty zsh \
qt5ct qt6ct kvantum nwg-look papirus-icon-theme \
pipewire wireplumber playerctl bluez bluez-utils blueman \
networkmanager network-manager-applet polkit-kde-agent \
cliphist wl-clipboard brightnessctl swww \
noto-fonts noto-fonts-cjk noto-fonts-emoji \
thunar ranger yazi eza bat fastfetch btop cava neovim \
firefox vesktop spotify-tui git code grim slurp swappy
```

#### From the AUR (yay):

```bash
yay -S --needed \
hyprpm hyprpaper hyprsunset \
sddm-catppuccin-theme-git \
wallust-git \
ttf-nerd-fonts-symbols-mono
```

</details>

### 4. Final Steps

1. **Reboot:** A full reboot is required to apply all changes and start the new services.
   ```bash
   sudo reboot
   ```

2. **Log In:** At the SDDM login screen, make sure you select the "Hyprland" session from the menu before entering your password.

3. **Set Your First Wallpaper:** Once on the desktop, press `SUPER + W` to open the wallpaper selector and choose your favorite. This will apply the initial color scheme.

4. **Enjoy your new desktop!**

---

## 🎨 Customization

This rice is highly customizable. Here are some common modifications you might want to make:

- **Wallpapers:** Add your own wallpapers to the wallpaper directory and use `SUPER + W` to select them
- **Colors:** The entire color scheme is generated from your wallpaper using wallust
- **Keybindings:** Edit `~/.config/hypr/hyprland.conf` to customize keybindings
- **Waybar:** Modify `~/.config/waybar/config` and `~/.config/waybar/style.css` for bar customization

---

## 🤝 Contributing

Feel free to fork this repository and submit pull requests for improvements. If you find bugs or have suggestions, please open an issue.

---

## 📝 License

This configuration is provided as-is for personal use. Feel free to modify and share!
