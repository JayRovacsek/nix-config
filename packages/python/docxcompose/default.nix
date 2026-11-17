{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage setuptools;
in
buildPythonPackage rec {
  pname = "docxcompose";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4saXA6L++tRHGq2ChhocXXs/SmaVEN5QS7NvQfZvbT4=";
  };

  build-system = [ setuptools ];

  dependencies = with python3Packages; [
    lxml
    python-docx
    setuptools
    six
    babel
  ];

  pythonImportsCheck = [ pname ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "*docxcompose* is a Python library for concatenating/appending Microsoft Word (.docx) files";
    downloadPage = "https://github.com/4teamwork/docxcompose/tags";
    homepage = "https://github.com/4teamwork/docxcompose";
    license = licenses.mit;
  };
}
