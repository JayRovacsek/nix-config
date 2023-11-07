{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libevtx-python";
  name = pname;
  version = "20221101";

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
    sha256 = "sha256-2ABOow7Dq9W2MS4J221OQ6OX1UqQZ9reseZpu7/qDTc=";
  };

  doCheck = false;
}