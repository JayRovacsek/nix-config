{ lib, stdenvNoCC, fetchurl, coreutils }:
let
  pname = "leap-seconds";
  version = "0.0.1";

  meta = with lib; {
    homepage = "https://www.ietf.org/timezones/data/leap-seconds.list";
    description = "Leapseconds file from IETF";
  };

  src = fetchurl {
    url = "https://www.ietf.org/timezones/data/leap-seconds.list";
    sha256 = "sha256-K0cR5nrz+LBPEzRzLwjLN/Mupz7uerQjoSQdIFpL0k8=";
  };

in stdenvNoCC.mkDerivation {
  inherit pname version src meta;

  buildCommand = ''
    ${coreutils}/bin/mkdir -p $out/share
    ln -s $src $out/share/leap-seconds.list
  '';
}
