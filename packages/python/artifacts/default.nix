{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "artifacts";

  version = "20230928";

  meta = with lib; {
    description =
      "A free, community-sourced, machine-readable knowledge base of forensic artifacts that the world can use both as an information source and within other tools.";
    platforms = platforms.all;
    homepage = "https://github.com/ForensicArtifacts/artifacts";
    downloadPage = "https://github.com/ForensicArtifacts/artifacts/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage pyyaml setuptools pip;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ pip pyyaml ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uRjyl35Xl+BuTfERNRumsm2LdEag62TuxrLz+n3xy48=";
  };
}
