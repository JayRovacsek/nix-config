{ lib, fetchPypi, python3Packages, ... }:
let inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in buildPythonPackage rec {
  pname = "libcreg-python";
  version = "20240419";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yXis81GljgJSP6N/Vl7xWkNq049w/lqVjYBEZWL4/04=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pycreg" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libcreg";
    homepage = "https://github.com/libyal/libcreg";
    downloadPage = "https://github.com/libyal/libcreg/releases";
    license = licenses.lgpl3Plus;
  };
}
