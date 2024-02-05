{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libcreg-python";
  name = pname;
  version = "20231123";

  meta = with lib; {
    description = "Python bindings module for libcreg";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libcreg/";
    downloadPage = "https://github.com/libyal/libcreg/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-W/O6G4QVozXi7xwTKsgnv0uEGBrLVEKVgiy2f2gWeCQ=";
  };

  doCheck = false;
}
