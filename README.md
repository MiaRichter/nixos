# 🚀 NixOS Configuration for DesMia

<div align="center">

![NixOS](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-333333?style=for-the-badge&logoColor=white)
![Flakes](https://img.shields.io/badge/Flakes-Enabled-brightgreen?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Stable-green?style=for-the-badge)

*A modern NixOS configuration with Hyprland Wayland compositor*

**Host**: DesMia  
**User**: akane  
**Shell**: Fish  
**DE/WM**: Hyprland (Wayland)

</div>

## 📋 System Overview

### 🖥️ Hardware Configuration
- **GPU**: NVIDIA RTX 4070ti super (with proprietary drivers)
- **Monitors**:
  - DP-2: Acer XF253Q (1920x1080 @ 240Hz)
  - DP-3: KTC AQW34H3 (3440x1440 @ 165Hz)
  - HDMI: ASUS (1920x1080 @ 75Hz)
- **CPU**: Intel i7 14700kf (with latest microcode)
- **Storage**: BTRFS root + VFAT boot

### 🌍 Location & Locale
- **Timezone**: Asia/Yekaterinburg (GMT+5)
- **Display Manager**: GDM with Wayland support
- **Session Type**: Wayland

### Quick start
 ```
 cd /etc/nixos/
 home-manager switch --flake .#akane@DesMia
 ```
