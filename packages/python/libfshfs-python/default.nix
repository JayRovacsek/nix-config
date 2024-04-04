{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libfshfs-python";

  version = "20240221";

  meta = with lib; {
    description = "Python bindings module for libfshfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfshfs/";
    downloadPage = "https://github.com/libyal/libfshfs/releases";
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
    sha256 = "sha256-7iSD02FCbgClPIbyK2jxbdpX91ccpUt+J0QTnPcSmbM=";
  };
}
