{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libvsgpt-python";
  name = pname;
  version = "20231122";

  meta = with lib; {
    description = "Python bindings module for libvsgpt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvsgpt/";
    downloadPage = "https://github.com/libyal/libvsgpt/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bFiM5FXllS9GR+XPc+dQCJ7aGV0EKmnPv4hB0UUDzcU=";
  };

  doCheck = false;
}
