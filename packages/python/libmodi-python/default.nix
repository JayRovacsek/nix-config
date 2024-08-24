{
  lib,
  zlib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage setuptools;
in
buildPythonPackage rec {
  pname = "libmodi-python";
  version = "20240305";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cZy1/RdFbT6OwIT/+MCVpdzRO8sz0P3I6EtcI9HdfNI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  pythonImportsCheck = [ "pymodi" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libmodi";
    downloadPage = "https://github.com/libyal/libmodi/releases";
    homepage = "https://github.com/libyal/libmodi";
    license = licenses.lgpl3Plus;
  };
}
