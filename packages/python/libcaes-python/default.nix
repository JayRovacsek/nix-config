{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libcaes-python";
  version = "20240114";

  meta = with lib; {
    description = "Python bindings module for libcaes";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libcaes";
    downloadPage = "https://github.com/libyal/libcaes/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bD2FPEM8p0bU8v6Vg4z4PsTwSWWfUy70I+/9j56aBUE=";
  };
}
