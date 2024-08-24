{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  coreutils,
  eww-wayland,
  ...
}:
with lib;
let
  name = "eww-music-info";
  version = "0.0.1";
  meta = {
    description = "Eww music info widget";
  };

  src = fetchFromGitHub {
    owner = "saimoomedits";
    repo = "eww-widgets";
    rev = "cfb2523a4e37ed2979e964998d9a4c37232b2975";
    hash = "sha256-yPSUdLgkwJyAX0rMjBGOuUIDvUKGPcVA5CSaCNcq0e8=";
  };

  phases = [
    "installPhase"
    "fixupPhase"
  ];

in
stdenvNoCC.mkDerivation {
  inherit
    name
    version
    meta
    phases
    src
    ;

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/bin
    ${coreutils}/bin/cp $src/eww/bar/scripts/pop $out/bin

    substituteInPlace $out/bin/pop \
      --replace 'EWW_BIN="$HOME/.local/bin/eww/eww"' 'EWW_BIN=${eww-wayland}/bin/eww' \
      --replace 'rm' '${coreutils}/bin/rm' \
      --replace 'touch' '${coreutils}/bin/touch'
  '';
}
