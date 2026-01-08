{ stdenv}:
{
  stdenv.mkDerivation rec {
    pname = "sddm-astronaut-theme";
    version = "1";
    
    # Укажите src относительно файла
    src = ./config/sddm/sddm-astronaut-theme;
    
    dontBuild = true;
    
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sddm-astronaut-theme
    '';
  };
}