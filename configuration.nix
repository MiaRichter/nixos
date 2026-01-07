{pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./system-packages.nix 
      ./gameready.nix
      ./nvidia.nix
      ./network-optimization.nix 
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "alice";
  
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  #networking.wireless.enable = false;
  time.timeZone = "Asia/Yekaterinburg";

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting ""
    '';
  };
  programs.dms-shell = {
    enable = true;

    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };
    
    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableClipboard = true;            # Clipboard history manager
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
  };
  programs.nix-ld.enable = true;
  
  services.displayManager.gdm = {
      enable = false;
      wayland = true;
    };
  services.displayManager.sddm = {
      enable = true;
  # 2. Включить экспериментальную поддержку Wayland
      wayland.enable = true;
  # 3. (Опционально) Установить тему, чтобы GUI не был пустым
      theme = "breeze";
};
  services.pipewire = {
     enable = true;
     wireplumber.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
   };
  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
 
  users.users.anrew = {
     shell = pkgs.fish;
     isNormalUser = true;
     extraGroups = [ "networkmanager" "wheel" "video" "audio" "storage" "disk" "plugdev" ];
   };

  # Язык системы
  i18n = {
    defaultLocale = "ru_RU.UTF-8";
    supportedLocales = [ "ru_RU.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };
  
  # Язык консоли
  console = {
    font = "cyr-sun16";
    keyMap = "ru";
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  environment = {
    # Переменные для Wayland
    sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    LANG = "ru_RU.UTF-8";
    LC_ALL = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    WLR_DRM_NO_MODIFIERS = "1";
  WLR_DRM_DEVICES = "/dev/dri/card0";
    };
};
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };
  services.udisks2.settings = {
    "udisks2.conf" = {
      "mount_options.conf" = {
        defaults = "uid=$UID,gid=$GID";
        ntfs_defaults = "uid=$UID,gid=$GID,umask=022";
        exfat_defaults = "uid=$UID,gid=$GID,umask=022";
      };
    };
  };
    security.polkit.enable = true;
    security.rtkit.enable = true;
    security.sudo.extraConfig = "Defaults pwfeedback";
    security.polkit.extraConfig = ''
  polkit.addRule(function(action, subject) {
    if (
      action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
      action.id == "org.freedesktop.udisks2.filesystem-mount" ||
      action.id == "org.freedesktop.udisks2.eject-media" ||
      action.id == "org.freedesktop.udisks2.power-off-drive"
    ) {
      return polkit.Result.YES;
    }
  });
'';
home-manager.users.anrew = { pkgs, ... }: {
  # ... ваш home.nix импортируется здесь, либо его содержимое ...
  imports = [ ./home.nix ];
};
nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
# Для автоматического монтирования в /run/media
  services.devmon.enable = true;  # автоматический мониторинг устройств
  # Nix settings
  nix.settings.auto-optimise-store = true;
  #nix.settings.sandbox = false; 
  system.stateVersion = "26.05";

}
