{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages)
    buildPythonPackage
    pyyaml
    pythonOlder
    setuptools
    ;
in
buildPythonPackage rec {
  pname = "acstore";
  version = "20240407";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yubHDEZ5nwltQW8sLEAhgyaXI0svHCS3a7Mewi6cvpg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  disabled = pythonOlder "3.8";

  pythonImportsCheck = [ pname ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files.";
    downloadPage = "https://github.com/log2timeline/acstore/releases";
    homepage = "https://github.com/log2timeline/acstore";
    license = licenses.asl20;
  };
}
