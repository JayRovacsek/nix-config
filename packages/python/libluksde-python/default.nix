{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libluksde-python";
  name = pname;
  version = "20231204";

  meta = with lib; {
    description = "Python bindings module for libluksde";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libluksde/";
    downloadPage = "https://github.com/libyal/libluksde/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SMWmZ76sJOrcC4YV2Ta22gdj+Gqg1/KDhd61+xM7Bh8=";
  };

  doCheck = false;
}
