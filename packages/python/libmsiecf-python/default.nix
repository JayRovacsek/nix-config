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
  pname = "libmsiecf-python";
  version = "20240425";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mdylekKq2hfUO8xQkbvr9F0X5hMp2zE3qkFvfyw9rhY=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pymsiecf" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libmsiecf";
    downloadPage = "https://github.com/libyal/libmsiecf/releases";
    homepage = "https://github.com/libyal/libmsiecf";
    license = licenses.lgpl3Plus;
  };
}
