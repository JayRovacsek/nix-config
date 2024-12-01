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
  pname = "libphdi-python";
  version = "20240508";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dXVH9X2lZpYqK5ki7yXC2YSCdCsiWy7rwFy8EXetohU=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyphdi" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libphdi";
    downloadPage = "https://github.com/libyal/libphdi/releases";
    homepage = "https://github.com/libyal/libphdi";
    license = licenses.lgpl3Plus;
  };
}
