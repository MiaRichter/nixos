{pkgs, ... }:
let
      # ИМПОРТИРУЙТЕ переменные здесь
    vars = if builtins.pathExists ./user.nix then import ./user.nix else {
      username = "user";
      hostname = "nixos";
    };
in
{
  systemd.services.shadowsocks-local = {
    enable = true;
    description = "Shadowsocks Client";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal --server-addr 83.243.123.135:443 --password AxoXuYLU6i2EklMDOzvOBv --encrypt-method chacha20-ietf-poly1305 --local-addr 127.0.0.1:1080 --fast-open";
      Restart = "on-failure";
      RestartSec = 5;
      User = "${vars.username}";
    };
  };
  environment.sessionVariables = {
  # Для Wayland/Hyprland
  NIXOS_OZONE_WL = "1";
  MOZ_ENABLE_WAYLAND = "1";
  
  # Прокси для приложений, которые их уважают
  
  http_proxy  = "socks5h://127.0.0.1:1080";
  https_proxy = "socks5h://127.0.0.1:1080";
  all_proxy   = "socks5h://127.0.0.1:1080";
  ftp_proxy = "socks5://127.0.0.1:1080";
  no_proxy = "localhost,127.0.0.1";
};
}