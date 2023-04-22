{ stdenv, lib, fetchurl }:
with lib;
let
  name = "sunset-river-pixelart-wallpaper";
  pname = name;
  version = "0.0.1";
  meta = {
    description = "Sunset Over River In the Evening Pixel Live Wallpaper";
  };

  src = fetchurl {
    url = "https://wallpaperwaifu.com/download/3003/";
    sha256 = "sha256-NRsLWVlFqxTEPmP8e4PlCVso3r+SFOtk5QiiJJiS+Rs=";
  };

  phases = [ "installPhase" ];

in stdenv.mkDerivation {
  inherit name pname version meta phases src;

  installPhase = ''
    mkdir -p $out/share

    ln -s $src $out/share/wallpaper.mp4
  '';
}
