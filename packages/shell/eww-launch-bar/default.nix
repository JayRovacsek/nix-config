{ stdenvNoCC, lib, fetchFromGitHub, coreutils, gawk, procps, eww-wayland, bspwm
, ... }:
with lib;
let
  name = "eww-launch-bar";
  version = "0.0.1";
  meta = { description = "Eww launch-bar script"; };

  src = fetchFromGitHub {
    owner = "saimoomedits";
    repo = "eww-widgets";
    rev = "cfb2523a4e37ed2979e964998d9a4c37232b2975";
    hash = "sha256-yPSUdLgkwJyAX0rMjBGOuUIDvUKGPcVA5CSaCNcq0e8=";
  };

  phases = [ "installPhase" "fixupPhase" ];

in stdenvNoCC.mkDerivation {
  inherit name version meta phases src;

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/bin
    ${coreutils}/bin/cp $src/eww/bar/launch_bar $out/bin

    substituteInPlace $out/bin/launch_bar \
      --replace 'EWW="$HOME/.local/bin/eww/eww' 'EWW="${eww-wayland}/bin/eww' \
      --replace 'touch' '${coreutils}/bin/touch' \
      --replace 'awk' '${gawk}/bin/awk' \
      --replace 'killall' '${coreutils}/bin/killall' \
      --replace 'rm' '${coreutils}/bin/rm' \
      --replace 'pidof' '${procps}/bin/pidof' \
      --replace 'bspc' '${bspwm}/bin/bspc'
  '';
}
