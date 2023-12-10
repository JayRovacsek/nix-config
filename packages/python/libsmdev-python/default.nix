{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libsmdev-python";
  name = pname;
  version = "20231128";

  meta = with lib; {
    description = "Python bindings module for libsmdev";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libsmdev/";
    downloadPage = "https://github.com/libyal/libsmdev/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-S0Hhbt+9HxLS86rwGL+4cvOCRRBeU49TMf4SXsmWl7E=";
  };

  doCheck = false;
}
