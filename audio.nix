# audio.nix
{ pkgs, ... }:

{
  # dms-shell визуализатор — можно включить, но он сильно грузит CPU
  programs.dms-shell.enableAudioWavelength = false;

  services.pipewire = {
    enable = true;
    
    # WirePlumber с повышенным приоритетом для плавного аудио
    wireplumber.enable = true;
    wireplumber.extraConfig = ''
      rt-priority = 75
    '';
    
    # ALSA и 32-бит поддержка
    alsa.enable = true;
    alsa.support32Bit = true;

    # PulseAudio через PipeWire, буферы увеличены по умолчанию в PipeWire
    pulse.enable = true;

    # Для стабильности добавим пользовательские настройки буфера
    extraConfig = ''
      context.exec = [
        { path = "${pkgs.pipewire}/libexec/pipewire-media-session" }
      ]
      default.clock.quantum = 1024
      default.clock.min-quantum = 1024
    '';
  };
}
