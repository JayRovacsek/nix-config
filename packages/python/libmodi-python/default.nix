{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libmodi-python";

  version = "20240305";

  meta = with lib; {
    description = "Python bindings module for libmodi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libmodi/";
    downloadPage = "https://github.com/libyal/libmodi/releases";
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
    sha256 = "sha256-cZy1/RdFbT6OwIT/+MCVpdzRO8sz0P3I6EtcI9HdfNI=";
  };
}
