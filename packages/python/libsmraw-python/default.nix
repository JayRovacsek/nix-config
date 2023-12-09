{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libsmraw-python";
  name = pname;
  version = "20231127";

  meta = with lib; {
    description = "Python bindings module for libsmraw";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libsmraw/";
    downloadPage = "https://github.com/libyal/libsmraw/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CUJlZCXjIDGnoOGwx0hqgDrMsLDcElBaB7bb/vOwfWo=";
  };

  doCheck = false;
}
