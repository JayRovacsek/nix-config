{ lib, fetchFromGitHub, python, ... }:
let
  pname = "OPNReport";
  name = pname;
  version = "0.1.0";

  meta = with lib; {
    description =
      "Generate meaningful output from your opnSense configuration backup, like Markdown documentation.";
    platforms = platforms.all;
    homepage = "https://github.com/AndyX90/OPNReport";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage defusedxml pyyaml;

in buildPythonPackage {
  inherit pname name version meta;

  propagatedBuildInputs = [ defusedxml pyyaml ];

  patches = [ ./bump-pyyaml-dependency.patch ];

  src = fetchFromGitHub {
    owner = "AndyX90";
    repo = pname;
    rev = "34d5902af0b5b720c50b8de54b233e2bce2ac59f";
    sha256 = "sha256-MlekeO9/XHIB9ePNW8jMBJKU8N2+27G1/G0oPW0eM5A=";
  };
}
