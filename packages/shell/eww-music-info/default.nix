{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  coreutils,
  mpc-cli,
  ffmpeg-headless,
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
    ${coreutils}/bin/cp $src/eww/bar/scripts/music_info $out/bin

    substituteInPlace $out/bin/music_info \
      --replace 'mpc' '${mpc-cli}/bin/mpc' \
      --replace 'ffmpeg' '${ffmpeg-headless}/bin/ffmpeg'
  '';
}
