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
  pname = "libfsext-python";
  version = "20240501";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sOqYWJBhjdHp5f3UEqHAHRQwXBmGaaMsQtvfB+wXUyY=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsext" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsext";
    homepage = "https://github.com/libyal/libfsext";
    downloadPage = "https://github.com/libyal/libfsext/releases";
    license = licenses.lgpl3Plus;
  };
}
