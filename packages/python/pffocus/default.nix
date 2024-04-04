{ lib, fetchFromGitHub, python3Packages, ... }:
let
  pname = "pfFocus";

  version = "0.1";

  meta = with lib; {
    description =
      "Generate meaningful output from your pfSense configuration backup, like Markdown documentation.";
    platforms = platforms.all;
    homepage = "https://github.com/TKCERT/pfFocus";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage defusedxml pip pyyaml;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ pip ];

  propagatedBuildInputs = [ defusedxml pyyaml ];

  src = fetchFromGitHub {
    owner = "TKCERT";
    repo = pname;
    rev = "7112221236ccac4a7ce3cd7f1c8e1c9d4cf54fd4";
    hash = "sha256-W1g8cWoICjKxr+wUbfO/XLBq9LGXgtRBj1X1aDBT0YA=";
  };
}
