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
      ./audio.nix
      ./hdr.nix
      ./monado.nix 
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  
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
  programs.xwayland.enable = true;

  services.flatpak = {
    enable = true;
  };
  services.postgresql = {
  enable = true;
  package = pkgs.postgresql_15; # или любая версия, которую хочешь
  dataDir = "/var/lib/postgresql/data";
  
  # Для разработки можно временно поставить trust
  authentication = ''
    # локальные соединения без пароля
    local   all             all                                     trust
    host    all             all             127.0.0.1/32            md5
  '';
};

  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
};

  services.desktopManager.plasma6.enable = true;

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
    # Добавьте этот блок после xdg.portal
  systemd.user.services.xdg-desktop-portal = {
    enable = true;
    description = "Portal service";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    
    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.portal.Desktop";
      ExecStart = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
      Restart = "on-failure";
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde  # ТОЛЬКО KDE портал
    ];
    
    config = {
      common = {
        default = [ "kde" ];  # Только KDE
      };
      plasma = {
        default = [ "kde" ];
      };
    };
  };
  
  security.wrappers.gamescope = {
    source = "${pkgs.gamescope}/bin/gamescope";
    capabilities = "cap_sys_admin+ep";
    owner = "root";
    group = "root";
    permissions = "u+rx,g+rx,o+rx";
  };

  # Добавляем dconf (важно для порталов)
  programs.dconf.enable = true;
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
  services.devmon.enable = true;
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "26.05";

}