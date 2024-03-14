{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "artifacts";
  name = pname;
  version = "20230928";

  meta = with lib; {
    description =
      "A free, community-sourced, machine-readable knowledge base of forensic artifacts that the world can use both as an information source and within other tools.";
    platforms = platforms.all;
    homepage = "https://github.com/ForensicArtifacts/artifacts";
    downloadPage = "https://github.com/ForensicArtifacts/artifacts/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage pyyaml;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uRjyl35Xl+BuTfERNRumsm2LdEag62TuxrLz+n3xy48=";
  };

  propagatedBuildInputs = [ pyyaml ];

  doCheck = false;
}
