{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  coreutils,
  gnugrep,
  gawk,
  procps,
  ...
}:
with lib;
let
  name = "eww-memory";
  version = "0.0.1";
  meta = {
    description = "Eww memory widget";
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
    ${coreutils}/bin/cp $src/eww/bar/scripts/memory $out/bin

    substituteInPlace $out/bin/memory \
      --replace 'free -m' '${procps}/bin/free -m' \
      --replace 'grep' '${gnugrep}/bin/grep' \
      --replace 'awk' '${gawk}/bin/awk'
  '';
}
