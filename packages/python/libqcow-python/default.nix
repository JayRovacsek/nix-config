{
  lib,
  zlib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in
buildPythonPackage rec {
  pname = "libqcow-python";
  version = "20240308";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6bPjrY0uiJu4nVWklso9lzyoAEMBASeGvLr2H5h5YWU=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyqcow" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libqcow";
    downloadPage = "https://github.com/libyal/libqcow/releases";
    homepage = "https://github.com/libyal/libqcow";
    license = licenses.lgpl3Plus;
  };
}
