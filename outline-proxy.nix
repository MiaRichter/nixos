# outline-proxy.nix
{ config, lib, pkgs, ... }:

let
  # Путь к вашим файлам Outline
  outlineDir = "/home/youruser/path/to/outline";
  
  # Деривация для OutlineProxyController
  outlineController = pkgs.writeShellScriptBin "OutlineProxyController" ''
    #!/bin/sh
    # Содержимое вашего OutlineProxyController скрипта
    ${builtins.readFile "${outlineDir}/OutlineProxyController"}
  '';
in
{
  # Добавляем группу
  users.groups.outlinevpn = {};
  
  # Добавляем пользователя в группу (замените youruser)
  users.users.youruser.extraGroups = [ "outlinevpn" ];
  
  # Создаем systemd сервис
  systemd.services.outline_proxy_controller = {
    description = "Outline Proxy Controller";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${outlineController}/bin/OutlineProxyController --owning-user-id=1000"; # Замените 1000 на ваш UID: id -u youruser
      Restart = "always";
      User = "root";
      Group = "outlinevpn";
      # Дополнительные настройки из вашего .service файла
    };
    
    # Скопируйте остальные параметры из outline_proxy_controller.service
    # например: Environment, WorkingDirectory и т.д.
  };
  
  # Добавляем пакет в systemPackages если нужно
  environment.systemPackages = [ outlineController ];
}