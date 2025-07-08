{
  lib,
  fetchFromGitHub,
  python3Packages,
  ...
}:
let
  pname = "OPNReport";

  version = "0.1.0";

  meta = with lib; {
    description = "Generate meaningful output from your opnSense configuration backup, like Markdown documentation.";
    homepage = "https://github.com/AndyX90/OPNReport";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages)
    buildPythonPackage
    defusedxml
    pyyaml
    setuptools
    ;

in
buildPythonPackage {
  inherit pname version meta;
  pyproject = true;

  dependencies = [
    defusedxml
    pyyaml
  ];

  build-system = [ setuptools ];

  patches = [ ./bump-pyyaml-dependency.patch ];

  doCheck = false;

  src = fetchFromGitHub {
    owner = "AndyX90";
    repo = pname;
    rev = "34d5902af0b5b720c50b8de54b233e2bce2ac59f";
    hash = "sha256-MlekeO9/XHIB9ePNW8jMBJKU8N2+27G1/G0oPW0eM5A=";
  };
}
