{ lib, stdenv, fetchurl, unzip, ... }:
stdenv.mkDerivation {
  pname = "all-the-mods-9-server";
  version = "9-0.2.29";

  src = fetchurl {
    url = "https://edge.forgecdn.net/files/4950/736/Server-Files-0.2.29b.zip";
    hash = "sha256-tGygKHjR7IMq60jyNNLvqWTTKwmDllNAmSpvgZUgLKM=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -rv $src $out/lib/minecraft

    chmod +x $out/lib/minecraft/startserver.sh

    ln -s $out/lib/minecraft/startserver.sh $out/bin/minecraft-server
  '';

  meta = with lib; {
    description = "All The Mods 9 Server";
    homepage = "https://github.com/AllTheMods/ATM-9";
    platforms = platforms.unix;
  };
}
