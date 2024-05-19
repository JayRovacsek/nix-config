{ lib, fetchPypi, python3Packages, ... }:
let inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in buildPythonPackage rec {
  pname = "liblnk-python";
  version = "20240423";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oCRa/Z9Pbj5dnGbWR8c8PiChrfBPMpL4mGuMqw6Gfx8=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pylnk" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for liblnk";
    downloadPage = "https://github.com/libyal/liblnk/releases";
    homepage = "https://github.com/libyal/liblnk";
    license = licenses.lgpl3Plus;
  };
}
