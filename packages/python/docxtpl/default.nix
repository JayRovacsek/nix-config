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
    six
    python-docx
    jinja2
    lxml
    ;
  inherit (self.packages.${system}) docxcompose;
in
buildPythonPackage rec {
  pname = "docxtpl";
  version = "0.16.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rh09TiYfZw0x3k7uLIw+AK8mhuev21xcy0Zb0GUNpus=";
  };

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
