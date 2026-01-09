{ stdenv }:
stdenv.mkDerivation rec {
  pname = "sddm-astronaut-theme";
  version = "1";
  
  src = /etc/nixos/config/sddm-theme/sddm-astronaut-theme;
  
  dontBuild = true;
  
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/sddm-astronaut-theme
  '';
}