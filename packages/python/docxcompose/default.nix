{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "docxcompose";
  version = "1.4.0";

  meta = with lib; {
    description =
      "*docxcompose* is a Python library for concatenating/appending Microsoft Word (.docx) files";
    platforms = platforms.all;
    homepage = "https://github.com/4teamwork/docxcompose";
    downloadPage = "https://github.com/4teamwork/docxcompose/tags";
    license = licenses.mit;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname version meta;

  propagatedBuildInputs = with python3Packages; [
    lxml
    python-docx
    setuptools
    six
    babel
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vPJ5mgtjwp63ej15mi8oRDrg9p+Gkf89dT9wa+UVw+k=";
  };
}
