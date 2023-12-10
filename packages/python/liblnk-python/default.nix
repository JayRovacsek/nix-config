{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "liblnk-python";
  name = pname;
  version = "20231120";

  meta = with lib; {
    description = "Python bindings module for liblnk";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/liblnk/";
    downloadPage = "https://github.com/libyal/liblnk/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uRZ0TyEWrgxOpNwDuZA5iGIvh0QG+nO4sGqK5K54e+w=";
  };

  doCheck = false;
}
