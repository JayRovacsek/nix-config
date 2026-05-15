{ lib, python3Packages, ... }:

python3Packages.buildPythonPackage {
  pname = "video-transcoder";
  version = "0.1.0";

  src = ./src;

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.openai
  ];

  meta = with lib; {
    description = "Video transcoder with LLM-driven optimisation";
    license = licenses.mit;
  };
}
