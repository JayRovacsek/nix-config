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
  pname = "libevt-python";

  version = "20240421";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z2kZ+rl7IEZpANJ4Vc9JiSMz5PLuQ5ySDoX6JgtZ1xU=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyevt" ];

  meta = rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libevt";
    homepage = "https://github.com/libyal/libevt";
    downloadPage = "https://github.com/libyal/libevt/releases";
    license = lib.licenses.lgpl3Plus;
  };
}
