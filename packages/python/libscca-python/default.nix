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
  pname = "libscca-python";
  version = "20240427";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4Z3atLkaB4XFf0zPcrCC2wVNrogSzBktqNv4kWJuN5U=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyscca" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libscca";
    downloadPage = "https://github.com/libyal/libscca/releases";
    homepage = "https://github.com/libyal/libscca";
    license = licenses.lgpl3Plus;
  };
}
