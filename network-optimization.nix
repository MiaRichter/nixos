{ config, pkgs, ... }:

{
  # Только проверенные рабочие зеркала
  nix.settings = {
    substituters = [
      # Российские (рабочие)
      "https://mirror.yandex.ru/mirrors/nix-channels/store"
      
      # Китайские (точно рабочие)
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      
      # Основные
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    
    # Многопоточность
    max-jobs = "auto";
    cores = 0;
    http-connections = 50;
    connect-timeout = 5;
    
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  
  # DNS который работает
  networking.nameservers = [ 
    "1.1.1.1"
    "8.8.8.8" 
    "77.88.8.8"
  ];
}