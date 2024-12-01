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
  pname = "libvhdi-python";
  version = "20240509";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5hyA2suR9DQh9IvKVWSvD7ujw5RWjL0B3Y+aCXblLvQ=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvhdi" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvhdi";
    downloadPage = "https://github.com/libyal/libvhdi/releases";
    homepage = "https://github.com/libyal/libvhdi";
    license = licenses.lgpl3Plus;
  };
}
