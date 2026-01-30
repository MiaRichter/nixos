{pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./personal-config.nix
      ./system-packages.nix 
      ./gameready.nix
      ./nvidia.nix
      ./network-optimization.nix 
      ./shadowsocks.nix 
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  #networking.wireless.enable = false;
  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
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
    quickshell.package = pkgs.quickshell;
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
  };
  services.flatpak = {
    enable = true;
  };
  services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  services.displayManager.sddm = {
      enable = false;
      wayland.enable = true;
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
  programs.appimage.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };
  programs.appimage.binfmt = true;
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

nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
# Для автоматического монтирования в /run/media
  services.devmon.enable = true;  # автоматический мониторинг устройств
  #services.openvpn.enable = true;
  
  # Nix settings
  nix.settings.auto-optimise-store = true;
  #nix.settings.sandbox = false; 
  system.stateVersion = "26.05";

}