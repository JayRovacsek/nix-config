{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libvsapm-python";
  version = "20240226";

  meta = with lib; {
    description = "Python bindings module for libvsapm";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvsapm";
    downloadPage = "https://github.com/libyal/libvsapm/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hiorYQ3xw6+rBKD0fn2lY2yzPcVxljYcmd13sUfYrkE=";
  };
}
