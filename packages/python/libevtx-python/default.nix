{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libevtx-python";
  name = pname;
  version = "20231121";

  meta = with lib; {
    description = "Python bindings module for libevtx";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libevtx/";
    downloadPage = "https://github.com/libyal/libevtx/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5XF0R1c8xVazJoLQ7jbKb/hHSGWsN2bXV9BOG6cOI9g=";
  };

  doCheck = false;
}
