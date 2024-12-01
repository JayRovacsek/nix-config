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
  pname = "libbde-python";
  version = "20240502";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CzCmnmpIrfBCCpcrPK16D9uO1LWv53PjYE5YMKbgRjI=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pybde" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files.";
    downloadPage = "https://github.com/libyal/libbde/releases";
    homepage = "https://github.com/libyal/libbde";
    license = licenses.lgpl3Plus;
  };
}
