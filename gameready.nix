{
  config,
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
    ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    lutris
    heroic
    # bottles
    # ryujinx
    # prismlauncher

    steam-tui
    steamcmd
    gamemode
    gamescope
    gamescope-wsi
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
      args = [ "--rt" ];
    };
  };
  services.xserver.enable = false; # Assuming no other Xserver 
  hardware.xone.enable = true; # support for the xbox controller USB dongle
  
}
