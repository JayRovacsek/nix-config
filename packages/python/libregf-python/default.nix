{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libregf-python";
  name = pname;
  version = "20231203";

  meta = with lib; {
    description = "Python bindings module for libregf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libregf/";
    downloadPage = "https://github.com/libyal/libregf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HGEX6grAfw3p4d2ee14jqgJw7FSueVjozaylrWkplzA=";
  };

  doCheck = false;
}
