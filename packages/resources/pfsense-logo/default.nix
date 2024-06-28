{ stdenvNoCC, lib, fetchurl }:
with lib;
let
  pname = "pfsense-logo";
  version = "0.0.1";

  src = fetchurl {
    url =
      "https://www.itandgeneral.com/wp-content/uploads/2023/11/pfsense-logo-square.png";
    hash = "sha256-gQBbcctIPVf1IqTT+9wvclF6H8sj/cZE25hrgT2B95s=";
  };

  phases = [ "installPhase" ];

in stdenvNoCC.mkDerivation {
  inherit pname version meta phases src;

  installPhase = ''
    mkdir -p $out/share

    cp $src $out/share/logo.png
  '';
}
