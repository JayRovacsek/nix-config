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
  pname = "libevtx-python";
  version = "20240504";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YkrFbZnVe1rMWNvLIaz1lsKuQFk433knSta4ENIIrdY=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyevtx" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libevtx";
    homepage = "https://github.com/libyal/libevtx";
    downloadPage = "https://github.com/libyal/libevtx/releases";
    license = licenses.lgpl3Plus;
  };
}
