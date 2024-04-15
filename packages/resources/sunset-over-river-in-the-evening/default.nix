{ stdenv, lib, fetchurl, ffmpeg-headless }:
with lib;
let
  pname = "sunset-over-river-in-the-evening-wallpaper";
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
  inherit pname version meta phases src;

  installPhase = ''
    mkdir -p $out/share

    # Convert to h265 for more efficient file size and format
    # at the cost of processing time up-front
    # Note stripping audio from these sources seemed to be redundant and 
    # not yield any notable filesize changes
    ${ffmpeg-headless}/bin/ffmpeg -i $src -vcodec libx265 -crf 28 $out/share/wallpaper.mp4
  '';
}
