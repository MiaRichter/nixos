{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";
  home.username = "anrew";
  home.homeDirectory = "/home/anrew";
  
  imports = [
    ./user-packages.nix
  ];
  nixpkgs.config.allowUnfree = true;
  # Настройки программ
  programs.git = {
    enable = true;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    
    # НОВЫЙ СИНТАКСИС: Профили
    profiles.default = {
      # Плагины (расширения) теперь здесь
      extensions = with pkgs.vscode-extensions; [
        # Языки программирования
        ms-python.python
        # ms-vscode.cpptools # все равно не загрузит из блокировки в рф
        golang.go
        redhat.java
        # ms-dotnettools.csharp
        redhat.vscode-yaml
        
        # Nix language support
        jnoortheen.nix-ide
        bbenoist.nix
        
        # Веб-разработка
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        
        # Внешний вид и удобство
        catppuccin.catppuccin-vsc
        pkief.material-icon-theme
        
        # Утилиты
        eamodio.gitlens
        # ms-azuretools.vscode-docker
        #github.copilot
      ];
      
      # Настройки редактора теперь здесь
      userSettings = {
      # ВСЕ ваши настройки здесь
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrains Mono', 'monospace'";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "git.autofetch" = true;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      
      # Пример дополнительных настроек
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      #"files.autoSave" = "afterDelay";
      
      # Настройки для конкретных языков
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "[python]" = {
        "editor.defaultFormatter" = "ms-python.python";
      };
      
      # Использовать open-vsx
      "extensions.gallery" = {
        "serviceUrl" = "https://open-vsx.org/vscode/gallery";
        "itemUrl" = "https://open-vsx.org/vscode/item";
      };
     
    "window.customMenuBarAltFocus" = false;
    "editor.stickyScroll.enabled" = false;
    };
    };
  };
  # Сервисы
  services.udiskie = {
    enable = true;
    tray = "auto";
    automount = true;
    notify = true;
  };
  
  # Переменные окружения
  home.sessionVariables = {
    EDITOR = "nano";
    BROWSER = "yandex-browser-stable";
  };
  
  # Включить управление файлами через home-manager
  xdg.enable = true;
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;
  
  # Или полная настройка mimeApps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };
}