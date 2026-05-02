{ fetchFromGitHub, stdenvNoCC, ... }:
stdenvNoCC.mkDerivation {
  pname = "orangepi-firmware";
  version = "2024.01.24";
  dontBuild = true;
  dontFixup = true;
  compressFirmware = false;

  src = fetchFromGitHub {
    owner = "orangepi-xunlong";
    repo = "firmware";
    rev = "db5e86200ae592c467c4cfa50ec0c66cbc40b158";
    hash = "sha256-v+4dv4U1vIF0kNCzbX8iZsGNkKWUDWdMmQOwuoFKWRo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware
    cp -a * $out/lib/firmware/

    runHook postInstall
  '';
}
