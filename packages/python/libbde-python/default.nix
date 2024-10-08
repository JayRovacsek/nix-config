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
  version = "20240223";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6Au2V4rZ1YAa4gumZXbiWs0DeJQbEM9oJJVjsjJCiYA=";
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
