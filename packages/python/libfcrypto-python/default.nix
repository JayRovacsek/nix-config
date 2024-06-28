{ lib, fetchPypi, python3Packages, ... }:
let inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in buildPythonPackage rec {
  pname = "libfcrypto-python";
  version = "20240414";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I7UKtc4+ELoijGzGpFHxrBml1MesRxRQ2/BC35bZ4AQ=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfcrypto" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfcrypto";
    downloadPage = "https://github.com/libyal/libfcrypto/releases";
    homepage = "https://github.com/libyal/libfcrypto";
    license = licenses.lgpl3Plus;
  };
}
