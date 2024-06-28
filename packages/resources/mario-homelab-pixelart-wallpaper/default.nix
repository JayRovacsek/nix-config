{ stdenvNoCC, lib, fetchurl }:
with lib;
stdenvNoCC.mkDerivation {
  pname = "mario-homelab-pixelart-wallpaper";
  version = "0.0.1";

  src = fetchurl {
    url =
      "https://r4.wallpaperflare.com/wallpaper/714/648/856/super-mario-pixel-art-super-mario-kart-computer-mushroom-hd-wallpaper-68367d38b0f07cb820dc81dea8c2d40a.jpg";
    hash = "sha256-OCX1xlCX1wqiKqFhzLiXA/ty01RdNUOP9d8ffqcSy9U=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/wallpaper.jpg
  '';

  meta.description = "Mario sitting in his home-lab Wallpaper";
}
