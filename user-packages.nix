{ pkgs, ... }:
{
home.packages = with pkgs; [
    # обои
    linux-wallpaperengine
    # Редакторы и IDE
    vscodium
    
    # Мессенджеры и коммуникация
    telegram-desktop
    discord
    # Мультимедиа
    mpv
    vlc
    # уведомления
    # Игры
    osu-lazer
    qbittorrent
    # Офис
    libreoffice-fresh
    firefox
    # Терминалы и оболочки
    kitty
    
    # Мониторинг
    btop
    fastfetch
    #hyprpolkitagent
    kdePackages.polkit-kde-agent-1
    jetbrains-toolbox
    # Hyprland экосистема
    rofi
    waybar
    hyprpaper
    hyprlock
    hypridle
    wofi
    hyprshot
    nwg-look
    mesa-demos
    # Утилиты разработчика
    dotnet-sdk
    dotnet-runtime
    gcc
    python3
    nodejs
    go
    rustc
    cargo
    winetricks
    # Модные утилиты
    lsd
    bat
    fd
    duf
    dust
    # для quickshell
    appimage-run
    wireguard-tools
    # # sddm theme
    # qt6.qtmultimedia
    # qt6.qtvirtualkeyboard 

    chromium
    protonplus
  ];
}
