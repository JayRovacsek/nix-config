{ stdenvNoCC, lib, fetchFromGitHub, coreutils, gnugrep, bspwm, ... }:
with lib;
let
  pname = "eww-workspace";
  version = "0.0.1";
  meta = { description = "Eww workspace script"; };

  src = fetchFromGitHub {
    owner = "saimoomedits";
    repo = "eww-widgets";
    rev = "cfb2523a4e37ed2979e964998d9a4c37232b2975";
    hash = "sha256-yPSUdLgkwJyAX0rMjBGOuUIDvUKGPcVA5CSaCNcq0e8=";
  };

  phases = [ "installPhase" "fixupPhase" ];

in stdenvNoCC.mkDerivation {
  inherit pname version meta phases src;

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/bin
    ${coreutils}/bin/cp $src/eww/bar/scripts/workspace $out/bin

    substituteInPlace $out/bin/workspace \
      --replace 'bspc' '${bspwm}/bin/bspc' \
      --replace 'grep' '${gnugrep}/bin/grep'
  '';
}
