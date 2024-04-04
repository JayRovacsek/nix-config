{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "dfdatetime";

  version = "20240330";

  meta = with lib; {
    description =
      "dfDateTime, or Digital Forensics date and time, provides date and time objects to preserve accuracy and precision.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/dfdatetime";
    downloadPage = "https://github.com/log2timeline/dfdatetime/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vRKhR+/pPLWhzo5s1sXK/oOIu+HZmjEgZflICnXsiJ0=";
  };
}
