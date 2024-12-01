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
  pname = "libvsgpt-python";
  version = "20240504";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fEVlO1+wVReOn4ryMP80gT1N5cHE/VuqGs4fgtG1XcI=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvsgpt" ];

  meta = with lib; rec {
    description = "Python bindings module for libvsgpt";

    homepage = "https://github.com/libyal/libvsgpt";
    downloadPage = "https://github.com/libyal/libvsgpt/releases";
    license = licenses.lgpl3Plus;
  };
}
