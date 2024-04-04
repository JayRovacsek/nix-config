{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libqcow-python";

  version = "20240308";

  meta = with lib; {
    description = "Python bindings module for libqcow";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libqcow/";
    downloadPage = "https://github.com/libyal/libqcow/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  buildInputs = [ zlib ];
  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6bPjrY0uiJu4nVWklso9lzyoAEMBASeGvLr2H5h5YWU=";
  };
}
