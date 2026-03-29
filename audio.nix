# audio.nix
{ ... }:

{

  # Оптимизация для реального времени
  security.rtkit.enable = true;

  # Оптимизация энергопотребления (опционально)
  powerManagement.cpuFreqGovernor = "performance";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    # Дополнительная конфигурация для фиксации частоты дискретизации
    extraConfig.pipewire."99-fix-rate" = {
      "context.properties" = {
        # Устанавливаем желаемую частоту дискретизации
        "default.clock.rate" = 48000;
        # Запрещаем все другие частоты, чтобы система не переключалась на 44100 Гц
        "default.clock.allowed-rates" = [ 48000 ];
      };
    };
  };
}