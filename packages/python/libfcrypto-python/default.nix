{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfcrypto-python";
  version = "20240115";

  meta = with lib; {
    description = "Python bindings module for libfcrypto";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfcrypto";
    downloadPage = "https://github.com/libyal/libfcrypto/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jk46cTZf5M3AfG2nS+5MYWV6UNGSHeYfXOlyI8cw0ec=";
  };
}
