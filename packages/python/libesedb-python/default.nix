{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libesedb-python";

  version = "20240202";

  meta = with lib; {
    description = "Python bindings module for libesedb";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libesedb/";
    downloadPage = "https://github.com/libyal/libesedb/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vUfVNNwpPBv0IREKj21MfKWPFXxvzhfyzRpre+3BjAU=";
  };
}
