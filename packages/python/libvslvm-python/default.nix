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
  pname = "libvslvm-python";
  version = "20240504";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VggKWu72cfFKXrDFiof2naWmQA6Jc2OWVSI0XVl9F3c=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvslvm" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvslvm";
    downloadPage = "https://github.com/libyal/libvslvm/releases";
    homepage = "https://github.com/libyal/libvslvm";
    license = licenses.lgpl3Plus;
  };
}
