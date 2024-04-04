{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libfsapfs-python";

  version = "20240218";

  meta = with lib; {
    description = "Python bindings module for libfsapfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsapfs/";
    downloadPage = "https://github.com/libyal/libfsapfs/releases";
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
    sha256 = "sha256-88F2RrVw9+JitNyg3mnkkMaWHKBDZoYxdvfeDRe+slw=";
  };
}
