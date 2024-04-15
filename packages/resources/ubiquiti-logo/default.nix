{ stdenvNoCC, lib, fetchurl }:
with lib;
let
  pname = "ubiquiti-logo";
  version = "0.0.1";

  src = fetchurl {
    url =
      "https://theme.zdassets.com/theme_assets/77613/c91f7f2114c450fecd5c4f39f8f960d6c5c77622.png";
    hash = "sha256-1Tt2AkkQRpHi35YCbcieLbMD55ioX7tmCxGp09E/hO0=";
  };

  phases = [ "installPhase" ];

in stdenvNoCC.mkDerivation {
  inherit pname version meta phases src;

  installPhase = ''
    mkdir -p $out/share

    cp $src $out/share/logo.png
  '';
}
