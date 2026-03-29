# Добавьте в imports или создайте отдельный файл monado.nix
{ config, pkgs, ... }:

{
  # ========== MONADO VR ==========
  services.monado = {
    enable = true;
    # Регистрируем Monado как системный OpenXR-рантайм
    defaultRuntime = true;
    # Включаем высокий приоритет для лучшей производительности
    highPriority = true;
  };

  # Udev правила для PS VR2 и других VR устройств
  services.udev.packages = with pkgs; [ 
    xr-hardware 
    # Дополнительно для PS4 Eye (если будете использовать для трекинга)
    (pkgs.writeTextFile {
      name = "ps4eye-udev";
      text = ''
        # PS4 Eye камера
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1415", ATTRS{idProduct}=="2000", MODE="0666"
        # PS VR2
        SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0cde", MODE="0666"
      '';
      destination = "/etc/udev/rules.d/99-psvr2.rules";
    })
  ];

  # Пакеты для VR
  environment.systemPackages = with pkgs; [
    monado
    monado-cli
    opencomposite
    # Для калибровки PS4 Eye
    v4l-utils
    python3Packages.pyusb
    # Для отладки
    vulkan-tools
    glxinfo
    # Для захвата аватара
    obs-studio
    v4l2loopback
  ];

  # Настройка V4L2 loopback для виртуальной камеры (нужно для аватара)
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="Virtual Camera" exclusive_caps=1
  '';

  # Переменные окружения для Monado и Steam
  environment.sessionVariables = {
    # Указываем Monado как OpenXR рантайм
    XDG_RUNTIME_DIR = "/run/user/1000";
    # Для лучшей производительности на NVIDIA
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
    # Отключаем GameMode для VR (может мешать)
    GAMEMODE_AUTO = "0";
  };

  # Настройка Steam для работы с OpenXR
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        # Позволяет Proton-играм видеть системный OpenXR
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        # Исправляет часовой пояс
        unset TZ
      '';
    };
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  # Добавляем в systemd пользовательские сервисы
  systemd.user.services.monado = {
    description = "Monado OpenXR runtime";
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.monado}/bin/monado-service";
      Restart = "on-failure";
      Environment = [
        "STEAMVR_LH_ENABLE=1"
        "XRT_COMPOSITOR_COMPUTE=1"
        "U_PACING_COMP_MIN_TIME_MS=5"
      ];
    };
  };

  # Для запуска OpenComposite с играми
  environment.etc."openvr/openvrpaths.vrpath".text = let
    steamPath = "/home/${config.users.users.?}/.steam/steam";
  in builtins.toJSON {
    version = 1;
    jsonid = "vrpathreg";
    external_drivers = null;
    config = [ "${steamPath}/config" ];
    log = [ "${steamPath}/logs" ];
    runtime = [ "${pkgs.opencomposite}/lib/opencomposite" ];
  };
}