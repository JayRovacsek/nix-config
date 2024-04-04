{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libmsiecf-python";

  version = "20240209";

  meta = with lib; {
    description = "Python bindings module for libmsiecf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libmsiecf/";
    downloadPage = "https://github.com/libyal/libmsiecf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C38pCImI7S3NHlR443IPuaR3eeij12TibsYzJcXBANA=";
  };
}
