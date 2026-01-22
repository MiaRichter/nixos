{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    shadowsocks-rust
    proxychains
  ];

  # Минимальная конфигурация systemd
  systemd.services.shadowsocks-local = {
    enable = true;
    description = "Shadowsocks Client";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal --server-addr 83.243.123.135:443 --password 'AxoXuYLU6i2EklMDOzvOBv' --encrypt-method chacha20-ietf-poly1305 --local-addr 127.0.0.1:1080 --fast-open";
      Restart = "on-failure";
      RestartSec = 5;
      User = "akane";
    };
  };

  environment.etc."proxychains.conf".text = ''
    strict_chain
    quiet_mode
    proxy_dns
    [ProxyList]
    socks5 127.0.0.1 1080
  '';
}