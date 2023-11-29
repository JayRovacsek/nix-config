{ stdenvNoCC, lib, fetchurl }:
with lib;
let
  name = "mario-homelab-pixelart-wallpaper";
  pname = name;
  version = "0.0.1";
  meta = { description = "Mario sitting in his home-lab Wallpaper"; };

  src = fetchurl {
    url =
      "https://r4.wallpaperflare.com/wallpaper/714/648/856/super-mario-pixel-art-super-mario-kart-computer-mushroom-hd-wallpaper-68367d38b0f07cb820dc81dea8c2d40a.jpg";
    sha256 = "sha256-OCX1xlCX1wqiKqFhzLiXA/ty01RdNUOP9d8ffqcSy9U=";
  };

  phases = [ "installPhase" ];

in stdenvNoCC.mkDerivation {
  inherit name pname version meta phases src;

  installPhase = ''
    mkdir -p $out/share

    cp $src $out/share/wallpaper.jpg
  '';
}
