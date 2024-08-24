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
  pname = "libfsfat-python";
  version = "20240220";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eABliX9tg+AMjbtr0g1BbjZUbgJE+uIljCB7GIMWs2w=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsfat" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsfat";
    downloadPage = "https://github.com/libyal/libfsfat/releases";
    homepage = "https://github.com/libyal/libfsfat";
    license = licenses.lgpl3Plus;
  };
}
