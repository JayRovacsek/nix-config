{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libsigscan-python";

  version = "20240219";

  meta = with lib; {
    description = "Python bindings module for libsigscan";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libsigscan/";
    downloadPage = "https://github.com/libyal/libsigscan/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iSsEQyHrBMcr+p+Vyei9J05+PXCWAvsR6G2EMVTXNGU=";
  };
}
