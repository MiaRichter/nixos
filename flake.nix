{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
    nixos-plymouth.url = "github:BeatLink/nixos-plymouth";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zapret-discord-youtube, nixos-plymouth, ... }: {
    
    nixosConfigurations.alice = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ./system-packages.nix
        ./gameready.nix
        ./nvidia.nix      
        nixos-plymouth.nixosModules.default
        zapret-discord-youtube.nixosModules.default
        
        {
          services.zapret-discord-youtube = {
            enable = true;
            config = "general(ALT)";
          };
        }
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.anrew = {
            imports = [
              ./home.nix
              ./user-packages.nix
            ];
          };
        }
      ];
    };

    # ДОБАВЛЕННЫЙ БЛОК - ваш путь к успешной работе home-manager
    homeConfigurations."anrew@alice" = home-manager.lib.homeManagerConfiguration {
      # Используем пакеты для x86_64-linux
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      
      # Модули конфигурации home-manager
      modules = [
        # Ваши основные файлы конфигурации
        ./home.nix
        ./user-packages.nix
        
        # Дополнительные настройки прямо здесь
        {
          home = {
            username = "anrew";
            homeDirectory = "/home/anrew";
            # Обязательно укажите версию, совпадающую с home.nix
            stateVersion = "26.05";
          };
        }
      ];
    };
  };
}
