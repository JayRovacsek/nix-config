{
  pkgs,
  lib,
  fetchPypi,
  python3Packages,
  self,
  ...
}:
let
  inherit (pkgs) system;
  inherit (python3Packages)
    buildPythonPackage
    jinja2
    poetry-core
    lxml
    python-docx
    setuptools
    six
    ;
  inherit (self.packages.${system}) docxcompose;
in
buildPythonPackage rec {
  pname = "docxtpl";
  version = "0.19.1";
  pyproject = true;

  pythonRemoveDeps = [ "black" ];

  nativeBuildInputs = [
    poetry-core
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WDaqtVg6guLoGwhvrhMM6U3AgPa3/g5D+D9OPj5drs8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    python-docx
    jinja2
    lxml
    docxcompose
  ];

  pythonImportsCheck = [ pname ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Use a docx as a jinja2 template";
    downloadPage = "https://github.com/elapouya/python-docx-template/tags";
    homepage = "https://github.com/elapouya/python-docx-template";
    license = licenses.lgpl21;
  };
}
