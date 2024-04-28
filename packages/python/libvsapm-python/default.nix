{ lib, fetchPypi, python3Packages, ... }:
let inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in buildPythonPackage rec {
  pname = "libvsapm-python";
  version = "20240226";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hiorYQ3xw6+rBKD0fn2lY2yzPcVxljYcmd13sUfYrkE=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsxfs" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvsapm";
    downloadPage = "https://github.com/libyal/libvsapm/releases";
    homepage = "https://github.com/libyal/libvsapm";
    license = licenses.lgpl3Plus;
  };
}
