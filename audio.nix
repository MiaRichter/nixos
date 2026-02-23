# audio.nix
{ ... }:

{

  # Оптимизация для реального времени
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;

    # Используем WirePlumber (стандартный менеджер сессий)
    wireplumber.enable = true;

    # Конфигурация для низкой задержки - ТОЛЬКО базовые настройки
    extraConfig = {
      pipewire = {
        "10-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [ 48000 44100 ]; # Добавим 44100 для совместимости
            "default.clock.quantum" = 256; # Начинаем с безопасного значения
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 2048;
          };
        };
      };
      
      # НЕ настраиваем pipewire-pulse принудительно - пусть wireplumber управляет
    };
  };

  # Повышаем лимиты для реального времени
  security.pam.loginLimits = [
    { domain = "@audio"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "@audio"; type = "-"; item = "rtprio"; value = "99"; }
    { domain = "@audio"; type = "-"; item = "nofile"; value = "1048576"; }
  ];
  
  # Оптимизация энергопотребления (опционально)
  powerManagement.cpuFreqGovernor = "performance";
}