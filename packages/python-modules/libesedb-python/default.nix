{ self, system, lib, stdenv, fetchPypi, python }:
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

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MJ6xvtuhxuf4sKGQ7aHolu8UlEcmN7dzbStFBSrVU+g=";
  };

  doCheck = false;
}
