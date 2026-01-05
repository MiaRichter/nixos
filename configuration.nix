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
  networking.hostName = "DesMia";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  
  time.timeZone = "Asia/Yekaterinburg";

  programs.fish = {
  enable = true;
  interactiveShellInit = ''
    set -U fish_greeting ""
  '';
};

  programs.nix-ld.enable = true;
  
  services.displayManager.gdm = {
      enable = true;
      wayland = true;
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
 
  users.users.akane = {
     shell = pkgs.fish;
     isNormalUser = true;
     extraGroups = [ "networkmanager" "wheel" "video" "audio" "storage" "disk" "plugdev" ];
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
