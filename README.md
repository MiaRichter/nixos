🚀 NixOS Configuration for DesMia
<div align="center">
https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white
https://img.shields.io/badge/Hyprland-333333?style=for-the-badge&logoColor=white
https://img.shields.io/badge/Flakes-Enabled-brightgreen?style=for-the-badge
https://img.shields.io/badge/Status-Stable-green?style=for-the-badge

A modern NixOS configuration with Hyprland Wayland compositor

Host: DesMia
User: akane
Shell: Fish
DE/WM: Hyprland (Wayland)

</div>
📋 System Overview
🖥️ Hardware Configuration
GPU: NVIDIA (with proprietary drivers)

Monitors:

DP-2: Acer XF253Q (1920x1080 @ 240Hz)

DP-3: KTC AQW34H3 (3440x1440 @ 165Hz)

CPU: Intel (with latest microcode)

Storage: BTRFS root + VFAT boot

🌍 Location & Locale
Timezone: Asia/Yekaterinburg (GMT+5)

Display Manager: GDM with Wayland support

Session Type: Wayland

🗂️ Project Structure
/etc/nixos/
├── flake.nix # Main flake configuration
├── configuration.nix # System configuration
├── hardware-configuration.nix # Hardware-specific settings
├── home.nix # Home-manager user configuration
├── system-packages.nix # System-wide packages
├── user-packages.nix # User packages (home-manager)
├── gameready.nix # Gaming optimizations
├── nvidia.nix # NVIDIA driver configuration
├── network-optimization.nix # Network settings
└── README.md # This file

⚡ Quick Start
Update System
cd /etc/nixos/
sudo nixos-rebuild switch --flake .#DesMia

Update User Configuration
cd /etc/nixos/
home-manager switch --flake .#akane@DesMia

🔧 Key Features
🎮 Gaming Ready
Steam with Proton-GE compatibility layer

Lutris & Heroic game launchers

Gamescope session support

MangoHud for performance overlay

Gamemode optimization

🖼️ Hyprland Wayland Desktop
Modern tiling window manager

Hardware-accelerated rendering

Customizable keybindings and window rules

Polkit agent for privilege escalation

Wayland-native applications

🛠️ Development Environment
VSCodium with Nix language support

Multiple programming languages:

Python, Go, Java, Rust, C#, Node.js

Git with pre-configured user

Nix language server (nil) and formatters

📦 Package Management
System packages: Managed via system-packages.nix

User packages: Managed via user-packages.nix

Unfree packages: Allowed (Discord, Steam, NVIDIA)

Binary caches: Optimized for RU/CN regions

⚙️ System Configuration Highlights
Network Optimization
Fast and reliable DNS servers
networking.nameservers = [ "1.1.1.1" "8.8.8.8" "77.88.8.8" ];

Multiple binary cache mirrors
nix.settings.substituters = [
"https://mirror.yandex.ru/mirrors/nix-channels/store"
"https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
"https://cache.nixos.org"
];

NVIDIA Configuration
Proprietary drivers with modesetting

VA-API support for hardware acceleration

Power management for suspend/resume

G-Sync/VRR support enabled

CUDA toolkit available

Security & Permissions
Polkit rules for automatic disk mounting

Sudo with password feedback

Udisks2 with automatic mounting

RTKit for real-time audio processing

🎨 User Experience
VSCodium Setup
Theme: Catppuccin Mocha

Font: JetBrains Mono

Extensions:

Nix IDE (language support)

Python, Go, Java, YAML

Prettier, ESLint

Catppuccin theme

GitLens, GitHub Copilot

Package Manager: Open VSX (open-source alternative)

Shell & Terminal
Default shell: Fish (with disabled greeting)

Terminal: Kitty

File manager: Nautilus

Disk utility: GNOME Disks + Udiskie

Multimedia
Audio: PipeWire with WirePlumber

Video: MPV, VLC

Screenshots: Hyprshot

Wallpaper: Hyprpaper

🚀 Performance Optimizations
Nix Garbage Collection
nix.gc = {
automatic = true;
dates = "weekly";
options = "--delete-older-than 7d";
};

System Tweaks
Latest Linux kernel

32-bit library support for gaming

Automatic store optimization

Parallel builds enabled

🔄 Update Workflow
Edit configuration files in /etc/nixos/

Apply system changes:
sudo nixos-rebuild switch --flake .#DesMia

Apply user changes:
home-manager switch --flake .#akane@DesMia

Test changes and rollback if needed

⚠️ Troubleshooting
Common Issues
"does not provide attribute" error

Ensure you're using the correct flake attribute name

Run nix flake show to see available configurations

Unfree package errors

Already configured with allowUnfree = true

VSCodium settings read-only

Normal behavior: settings managed by home-manager

Edit home.nix and re-run home-manager

Network issues in Russia

Pre-configured with Yandex and Chinese mirrors

Multiple DNS servers for reliability

Logs & Debugging
View build logs
nix log /nix/store/[hash]-home-manager-generation.drv

Check system journal
journalctl -xe

Test network connectivity
curl -I https://cache.nixos.org

📄 License & Credits
This configuration is based on:

NixOS - Reproducible system configuration

Home Manager - User environment management

Hyprland - Modern Wayland compositor

Community flakes and overlays

🔗 Useful Links
NixOS Manual

Home Manager Options

Hyprland Wiki

Nix Package Search

<div align="center">
Maintained by MiaRichter · Last Updated: January 2025

"Reproducible, declarative, and modern system configuration"

</div>