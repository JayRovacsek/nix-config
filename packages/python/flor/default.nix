{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage setuptools;
in
buildPythonPackage rec {
  pname = "Flor";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H6wQHhYURtuy7lN51blQuwFf5tkFaDhaVJtTjKEv6UI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "flor" ];

  meta = rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Flor - An efficient Bloom filter implementation in Python";
    downloadPage = "https://github.com/DCSO/flor/releases";
    homepage = "https://github.com/DCSO/flor";
    license = lib.licenses.bsd3;
  };
}
