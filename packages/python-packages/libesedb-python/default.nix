{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libesedb-python";
  name = pname;
  version = "20220806";

  meta = with lib; {
    description = "Python bindings module for libesedb";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libesedb/";
    downloadPage = "https://github.com/libyal/libesedb/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MJ6xvtuhxuf4sKGQ7aHolu8UlEcmN7dzbStFBSrVU+g=";
  };

  doCheck = false;
}