{ lib, zlib, fetchPypi, python3Packages, ... }:
let inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in buildPythonPackage rec {
  pname = "libfsapfs-python";
  version = "20240218";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-88F2RrVw9+JitNyg3mnkkMaWHKBDZoYxdvfeDRe+slw=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsapfs" ];

  meta = with lib; {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsapfs";
    downloadPage = "https://github.com/libyal/libfsapfs/releases";
    homepage = "https://github.com/libyal/libfsapfs";
    license = licenses.lgpl3Plus;
  };
}
