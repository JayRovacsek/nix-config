{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libmsiecf-python";
  name = pname;
  version = "20231203";

  meta = with lib; {
    description = "Python bindings module for libmsiecf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libmsiecf/";
    downloadPage = "https://github.com/libyal/libmsiecf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R6KqJthZI8L0LVElQVBRVFb0bRLPlbf+4k1ejj4iNIo=";
  };

  doCheck = false;
}
