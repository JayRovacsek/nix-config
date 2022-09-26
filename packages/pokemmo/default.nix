{ lib, stdenv, fetchurl, makeDesktopItem, unzip, makeWrapper
, adoptopenjdk-jre-bin, copyDesktopItems }:
let
  desktopItem = makeDesktopItem {
    name = "PokeMMO";
    desktopName = "PokeMMO";
    exec = "pokemmo";
    icon = "pokemmo";
  };
in stdenv.mkDerivation {
  pname = "pokemmo";
  version = "0.0.1";

  src = fetchurl {
    url = "https://pokemmo.com/download_file/1/";
    sha256 = "CF+mpbcAqZ0XbhpPEWpdKyhLZ5FXuxW8Wbal+pwU/6c=";
  };

  phases = [ "installPhase" ];

  nativeBuildInputs =
    [ adoptopenjdk-jre-bin makeWrapper unzip copyDesktopItems ];

  installPhase = ''
    # Make required directories
    mkdir -p $out/share/pokemmo
    mkdir -p $out/bin

    # unzip src
    unzip $src -d pokemmo-client

    # copy unzipped files to share location
    cp -r pokemmo-client/* $out/share/pokemmo/

    makeWrapper ${adoptopenjdk-jre-bin}/bin/java $out/bin/pokemmo \
      --chdir "$out/share/pokemmo" \
      --add-flags "-Xmx384M -Dfile.encoding="UTF-8" -cp $out/share/pokemmo/PokeMMO.exe com.pokeemu.client.Client"

    install -Dm644 pokemmo-client/data/icons/128x128.png $out/share/icons/pokemmo.png
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "A game that is a bit like the board game Risk or RisiKo";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
