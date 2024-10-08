{
  stdenv,
  lib,
  fetchurl,
  ffmpeg-headless,
}:
with lib;
stdenv.mkDerivation {
  pname = "may-sitting-near-waterfall-pokemon-emerald";
  version = "0.0.1";

  src = fetchurl {
    url = "https://wallpaperwaifu.com/download/3273/";
    hash = "sha256-q9fm9dg65oGCtoYERXUqWg/HC9HTA9XbboIXEfhTHMk=";
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

  meta.description = "May Sitting Near Waterfall Pokemon Emerald Pixel Live Wallpaper";
}
