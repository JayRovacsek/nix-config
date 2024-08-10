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
  version = "20240303";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p5Se/gk6g2DdBEYk1IkwAs5VvkTnbq4Xe+7WNlnvKCc=";
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
