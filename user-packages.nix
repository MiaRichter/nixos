{ pkgs, ... }:
{
home.packages = with pkgs; [
    # обои
    linux-wallpaperengine
    # Редакторы и IDE
    vscodium
    #jetbrains.rider
    # Мессенджеры и коммуникация
    telegram-desktop
    discord
    # Мультимедиа
    mpv
    vlc
    # уведомления
    # Игры
    osu-lazer
    
    # Офис
    libreoffice-fresh
    
    # Терминалы и оболочки
    kitty
    
    # Мониторинг
    btop
    fastfetch
    hyprpolkitagent
    
    # Hyprland экосистема
    rofi
    waybar
    hyprpaper
    hyprlock
    hypridle
    wofi
    hyprshot
    nwg-look
    
    # Утилиты разработчика
    dotnet-sdk
    gcc
    python3
    nodejs
    go
    rustc
    cargo
    # Модные утилиты
    lsd
    bat
    fd
    duf
    dust
    # для quickshell
    quickshell

    # # sddm theme
    # qt6.qtmultimedia
    # qt6.qtvirtualkeyboard 
  ];
}
