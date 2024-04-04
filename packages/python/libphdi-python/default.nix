{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libphdi-python";

  version = "20240307";

  meta = with lib; {
    description = "Python bindings module for libphdi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libphdi/";
    downloadPage = "https://github.com/libyal/libphdi/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qn4iZkVpWcm2leVWpJx0l3BFYBY3U8nsR6EzgBz1Uak=";
  };
}
