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
  pname = "libsmraw-python";
  version = "20240506";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bGjrv8hji0URqRWLeyvY/yg09MyUlZ5S9/Fo4yoB+k0=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pysmraw" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libsmraw";
    downloadPage = "https://github.com/libyal/libsmraw/releases";
    homepage = "https://github.com/libyal/libsmraw";
    license = licenses.lgpl3Plus;
  };
}
