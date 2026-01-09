{ config, pkgs, ... }:
{
  networking.hostName = "alice";
  users.users.anrew = {
     shell = pkgs.fish;
     isNormalUser = true;
     extraGroups = [ "networkmanager" "wheel" "video" "audio" "storage" "disk" "plugdev" ];
   };
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "anrew";
  home-manager.users.anrew = { pkgs, ... }: {
    # ... ваш home.nix импортируется здесь, либо его содержимое ...
    imports = [ ./home.nix ];
  };
}