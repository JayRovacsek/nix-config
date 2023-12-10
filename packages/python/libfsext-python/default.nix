{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfsext-python";
  name = pname;
  version = "20231129";

  meta = with lib; {
    description = "Python bindings module for libfsext";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsext/";
    downloadPage = "https://github.com/libyal/libfsext/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ijhu/0QzRVzrJQTU5UsPMfRauzaeK6maR3Vdo2k80UI=";
  };

  doCheck = false;
}
