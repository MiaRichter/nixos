{
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "mangohud"           
      "goverlay"           
      "protonup-qt"        
    ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    lutris
    heroic
    protonup-qt 
    mangohud  
    steam-tui
    steamcmd
    gamemode
    gamescope
    gamescope-wsi
    goverlay 
    steam-run
    wineWowPackages.staging
  ];
  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };
  services.xserver.enable = false; # Assuming no other Xserver 
  hardware.xone.enable = true; # support for the xbox controller USB dongle
}
