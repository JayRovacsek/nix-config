{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libolecf-python";

  version = "20240212";

  meta = with lib; {
    description = "Python bindings module for libolecf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libolecf/";
    downloadPage = "https://github.com/libyal/libolecf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jKm4eo5UVnlDyRqGz7oOIzRIsJ2jeIspzeDVi1xHOPY=";
  };
}
