{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let

  inherit (python3Packages)
    buildPythonPackage
    pip
    pyyaml
    pythonOlder
    setuptools
    ;

in
buildPythonPackage rec {
  pname = "dtfabric";
  version = "20260506";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n/z2OD3vZrEKoYC3eRVIx6XpgKwTbTaKqp2O2cg11fs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pip
    pyyaml
  ];

  disabled = pythonOlder "3.8";

  pythonImportsCheck = [ pname ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "dtFabric, or data type fabric, is a project to manage data types and structures, as used in the libyal projects.";
    downloadPage = "https://github.com/libyal/dtfabric/releases";
    homepage = "https://github.com/libyal/dtfabric";
    license = licenses.asl20;
  };
}
