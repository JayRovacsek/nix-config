{ lib, fetchPypi, python3Packages, ... }:
let inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in buildPythonPackage rec {
  pname = "libvsgpt-python";
  version = "20240228";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6knIN5K0m0s5Wp7++tEuCBhhhu+Ego2OvRv87RAA3lQ=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvsgpt" ];

  meta = with lib; rec {
    description = "Python bindings module for libvsgpt";

    homepage = "https://github.com/libyal/libvsgpt";
    downloadPage = "https://github.com/libyal/libvsgpt/releases";
    license = licenses.lgpl3Plus;
  };
}
