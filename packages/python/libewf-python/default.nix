{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libewf-python";

  version = "20231119";

  meta = with lib; {
    description = "Python bindings module for libewf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libewf/";
    downloadPage = "https://github.com/libyal/libewf/releases";
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
    sha256 = "sha256-35hPmLSVZnAQTputkeputePD2pVwYOt7qerbAe8CE4I=";
  };
}
