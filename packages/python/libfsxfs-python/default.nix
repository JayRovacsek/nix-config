{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in
buildPythonPackage rec {
  pname = "libfsxfs_python";
  version = "20260703";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uGlUMCRc8LFnT3Z/rN4YtB3myZk5iD+OBQRSJxsgyPI=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsxfs" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsxfs";
    downloadPage = "https://github.com/libyal/libfsxfs/releases";
    homepage = "https://github.com/libyal/libfsxfs";
    license = licenses.lgpl3Plus;
  };
}
