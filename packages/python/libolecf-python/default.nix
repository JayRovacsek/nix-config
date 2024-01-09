{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libolecf-python";
  name = pname;
  version = "20231203";

  meta = with lib; {
    description = "Python bindings module for libolecf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libolecf/";
    downloadPage = "https://github.com/libyal/libolecf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hQNlUJDLlkGPrzgFJVt+SF8bluyRLemkFHJyCutvMMA=";
  };

  doCheck = false;
}
