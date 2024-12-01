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
  pname = "libvmdk-python";
  version = "20240510";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bFd1sq2/Z1lGf9tWvkaSbKcJleO9WmNf5MFbdGavpz8=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvmdk" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvmdk";
    downloadPage = "https://github.com/libyal/libvmdk/releases";
    homepage = "https://github.com/libyal/libvmdk";
    license = licenses.lgpl3Plus;
  };
}
