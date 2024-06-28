{ stdenv, lib, fetchurl, ffmpeg-headless }:
with lib;
stdenv.mkDerivation {
  pname = "sunset-over-river-in-the-evening";
  version = "0.0.1";

  src = fetchurl {
    url = "https://wallpaperwaifu.com/download/3003/";
    hash = "sha256-NRsLWVlFqxTEPmP8e4PlCVso3r+SFOtk5QiiJJiS+Rs=";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/share

    # Convert to h265 for more efficient file size and format
    # at the cost of processing time up-front
    # Note stripping audio from these sources seemed to be redundant and 
    # not yield any notable filesize changes
    ${ffmpeg-headless}/bin/ffmpeg -i $src -vcodec libx265 -crf 28 $out/share/wallpaper.mp4
  '';

  meta.description = "Sunset Over River In the Evening Pixel Live Wallpaper";
}
