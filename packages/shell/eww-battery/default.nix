{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  coreutils,
  gnugrep,
  ...
}:
with lib;
let
  pname = "eww-battery";
  version = "0.0.1";
  meta = {
    description = "Eww battery widget";
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
    pname
    version
    meta
    phases
    src
    ;

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/bin
    ${coreutils}/bin/cp $src/eww/bar/scripts/battery $out/bin

    substituteInPlace $out/bin/battery \
      --replace 'cat' '${coreutils}/bin/cat' \
      --replace 'grep' '${gnugrep}/bin/grep'
  '';
}
