# /etc/nixos/shadowsocks.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    shadowsocks-rust
    proxychains
  ];

  systemd.services.shadowsocks-local = {
    enable = true;
    description = "Shadowsocks Client";
    after = ["network.target" "NetworkManager-wait-online.service"];
    wants = ["NetworkManager-wait-online.service"];
    wantedBy = ["multi-user.target"];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -s 158.173.184.60 -p 443 -k 'K33iHg3S7rJhbKeKYNnHvE' -m 'chacha20-ietf-poly1305' -l 1080 --fast-open";
      Restart = "always";
      RestartSec = 10;
      User = "anrew";
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
    
    # Ждать доступность сети
    unitConfig = {
      StartLimitIntervalSec = 500;
      StartLimitBurst = 5;
    };
  };

  # Прокси переменные для Wayland/Hyprland
  environment.sessionVariables = {
    # Ваши текущие переменные
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    LANG = "ru_RU.UTF-8";
    LC_ALL = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    WLR_DRM_NO_MODIFIERS = "1";
    WLR_DRM_DEVICES = "/dev/dri/card0";
    
    # Добавьте прокси переменные
    ALL_PROXY = "socks5://127.0.0.1:1080";
    HTTP_PROXY = "socks5://127.0.0.1:1080";
    HTTPS_PROXY = "socks5://127.0.0.1:1080";
    SOCKS_PROXY = "127.0.0.1:1080";
    NO_PROXY = "localhost,127.0.0.1";
  };

  # Настройка proxychains
  environment.etc."proxychains.conf".text = ''
    strict_chain
    quiet_mode
    proxy_dns
    remote_dns_subnet 224
    tcp_read_time_out 15000
    tcp_connect_time_out 8000
    localnet 127.0.0.0/255.0.0.0
    
    [ProxyList]
    socks5 127.0.0.1 1080
  '';

  # Копия для proxychains4
  environment.etc."proxychains4.conf".source = config.environment.etc."proxychains.conf".source;

  # Полезные алиасы для fish
  programs.fish.interactiveShellInit = ''
    set -U fish_greeting ""
    
    # Прокси алиасы
    alias myip='curl --socks5 127.0.0.1:1080 -s ifconfig.me && echo'
    alias proxy-start='sudo systemctl start shadowsocks-local'
    alias proxy-stop='sudo systemctl stop shadowsocks-local'
    alias proxy-status='sudo systemctl status shadowsocks-local'
    alias proxy-logs='sudo journalctl -u shadowsocks-local -f'
    alias proxy-check='curl --socks5 127.0.0.1:1080 -s ifconfig.me'
    
    # Запуск приложений через прокси
    alias yandex-proxy='proxychains yandex-browser-stable'
    alias firefox-proxy='proxychains firefox'
    alias chromium-proxy='proxychains chromium'
  '';
}