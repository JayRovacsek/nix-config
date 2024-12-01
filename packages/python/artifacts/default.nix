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
    pythonOlder
    pyyaml
    setuptools
    ;
in
buildPythonPackage rec {
  pname = "artifacts";
  version = "20240518";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0FWOt/qHYZjeHasjKO9Im9mlI7h82gaZqR0BDWMFEj4=";
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
    description = "A free, community-sourced, machine-readable knowledge base of forensic artifacts that the world can use both as an information source and within other tools.";
    homepage = "https://github.com/ForensicArtifacts/artifacts";
    downloadPage = "https://github.com/ForensicArtifacts/artifacts/releases";
    license = licenses.asl20;
  };
}
