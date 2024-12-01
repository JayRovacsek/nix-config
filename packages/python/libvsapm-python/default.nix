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
  pname = "libvsapm-python";
  version = "20240503";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QLsfTZhdCysfdQNIyE62wDRfBEuqdiio0u9B5qOlSIM=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvsapm" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvsapm";
    downloadPage = "https://github.com/libyal/libvsapm/releases";
    homepage = "https://github.com/libyal/libvsapm";
    license = licenses.lgpl3Plus;
  };
}
