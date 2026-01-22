{ config, lib, pkgs, ... }:

let
  # Ваше имя пользователя
  username = "anrew";  # Замените на ваше имя пользователя
  
  # Путь к файлам Outline
  outlineDir = "./config/";  # Укажите правильный путь
  
  # Деривация для OutlineProxyController
  outlineController = pkgs.writeShellScriptBin "OutlineProxyController" ''
    #!/bin/sh
    # Содержимое вашего OutlineProxyController скрипта
    # Вставьте сюда содержимое файла OutlineProxyController
    # Или используйте: ${builtins.readFile "${outlineDir}/OutlineProxyController"}
    echo "Outline Proxy Controller running"
    # ... ваш код здесь ...
  '';
in
{
  # Добавляем группу
  users.groups.outlinevpn = {};
  
  # Настраиваем пользователя (УБЕДИТЕСЬ ЧТО ЭТО УЖЕ ЕСТЬ В КОНФИГЕ!)
  # Не дублируйте определение пользователя, если он уже есть
  # Вместо этого добавляем только extraGroups
  users.users.${username} = {
    # Если пользователь уже определен в основном конфиге, 
    # НЕ добавляйте isNormalUser/isSystemUser здесь
    # Просто добавьте группу:
    extraGroups = [ "outlinevpn" ];
  };
  
  # Systemd сервис
  systemd.services.outline_proxy_controller = {
    enable = true;
    description = "Outline Proxy Controller";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${outlineController}/bin/OutlineProxyController --owning-user-id=${toString config.users.users.${username}.uid}";
      Restart = "always";
      User = "root";
      Group = "outlinevpn";
    };
  };
}