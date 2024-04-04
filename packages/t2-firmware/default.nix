{ lib, stdenvNoCC, fetchurl, findutils, coreutils }:
let
  pname = "t2-firmware";

  version = "0.0.1";

  meta = with lib; {
    homepage = "https://github.com/t2linux";
    description =
      "Patches to Linux and associated distros for Apple T2-based devices";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };

  src = fetchurl {
    url =
      "https://nextcloud.rovacsek.com/s/REn8SsJCdNawNPm/download/firmware.tar.gz";
    sha256 = "sha256-wckR1MgynoDKqRKlttKiE32FIBbw6xbcjUb984dfoTc=";
  };

in stdenvNoCC.mkDerivation {
  inherit pname version src meta;

  buildCommand = ''
    ${coreutils}/bin/mkdir -p $out/lib/firmware
    tar -xf $src
    ${findutils}/bin/find . -maxdepth 1 -type f -not -name '*.tar.gz' -not -name 'env-vars' -exec ${coreutils}/bin/mv {} $out/lib/firmware \;
  '';
}
