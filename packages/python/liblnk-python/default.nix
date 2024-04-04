{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "liblnk-python";

  version = "20240120";

  meta = with lib; {
    description = "Python bindings module for liblnk";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/liblnk/";
    downloadPage = "https://github.com/libyal/liblnk/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BKQPSariyRrYLuiGLeg9GIr0A/F+xgR6LZA0wrIsG3M=";
  };
}
