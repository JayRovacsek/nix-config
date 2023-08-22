{ lib, fetchFromGitHub, python3Packages, ... }:
let
  pname = "pfFocus";
  name = pname;
  version = "0.1.0";

  meta = with lib; {
    description =
      "Generate meaningful output from your pfSense configuration backup, like Markdown documentation.";
    platforms = platforms.all;
    homepage = "https://github.com/TKCERT/pfFocus";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage defusedxml pyyaml;

in buildPythonPackage {
  inherit pname name version meta;

  propagatedBuildInputs = [ defusedxml pyyaml ];

  patches = [ ./bump-pyyaml-dependency.patch ];

  src = fetchFromGitHub {
    owner = "TKCERT";
    repo = pname;
    rev = "7d3b027f9887af0c98cc3bdfe15388adc3208231";
    sha256 = "sha256-LWxV4vWugVXyFsHGbtqyprLbYMz8stpEniYZRqBmULI=";
  };

  doCheck = false;
}
