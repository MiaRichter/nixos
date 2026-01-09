{ config, pkgs, ... }:
let
      # ИМПОРТИРУЙТЕ переменные здесь
    vars = if builtins.pathExists ./user.nix then import ./user.nix else {
      username = "user";
      hostname = "nixos";
    };
in
{
  networking.hostName = "${vars.hostname}";
  users.users.${vars.username} = {
     shell = pkgs.fish;
     isNormalUser = true;
     extraGroups = [ "networkmanager" "wheel" "video" "audio" "storage" "disk" "plugdev" ];
   };
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "${vars.username}";
  home-manager.users.${vars.username} = { pkgs, ... }: {
    # ... ваш home.nix импортируется здесь, либо его содержимое ...
    imports = [ ./home.nix ];
  };
}