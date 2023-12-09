{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libevt-python";
  name = pname;
  version = "20231121";

  meta = with lib; {
    description = "Python bindings module for libevt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libevt/";
    downloadPage = "https://github.com/libyal/libevt/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8TVAWaPx+QNHg+/m+7OXuZ201nBnym7Kxa8HnmtMkF0=";
  };

  doCheck = false;
}
