{ pkgs, ... }:
{
fonts.packages = with pkgs; [
    # Основные Nerd Fonts
    nerd-fonts.jetbrains-mono    # Уже есть
    nerd-fonts.fira-code         # Нужно добавить
    nerd-fonts.symbols-only      # Нужно добавить
    dejavu_fonts
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    freefont_ttf
    
    # Noto шрифты (много языков)
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-monochrome-emoji
    
    # Microsoft совместимые (для игр)
    corefonts  # или vistafonts
    # или если нет в официальных репозиториях:
    # (from nixos-unstable) microsoft-fonts
    
    # Дополнительные
    ubuntu-classic
    fira-code
    fira-code-symbols
    # Font Awesome
    font-awesome                # Включает все версии
  ];
  environment.systemPackages = with pkgs; [
    # Системные утилиты (нужны всем)
    #(callPackage ./sddm-theme.nix {})
    vim
    nano
    git
    curl
    wget
    pciutils
    usbutils
    lm_sensors
    dmidecode
    # Драйверы и утилиты файловых систем
    ntfs3g
    exfat
    dosfstools
    hfsprogs
    btrfs-progs
    grc
    # Фонты (системные)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    dejavu_fonts
    noto-fonts
    home-manager
    # Базовые графические утилиты
    nautilus
    pavucontrol
    gnome-disk-utility
    
    # Сетевые сервисы
    networkmanagerapplet
    
    # Безопасность
    gnupg
    openssl

    # Архиваторы - УЖЕ В system-packages.nix
    zip
    unzip
    p7zip
    nil  # Языковой сервер для Nix (для nix-ide плагина)
    nixpkgs-fmt  # Форматтер для Nix файлов
    alejandra  # Альтернативный форматтер для Nix
   # Прочее
    flatpak
    gdm-settings
    webkitgtk_4_1
    patchelf
    libxml2
    jq
    libnotify
    numlockx
  ];
}
