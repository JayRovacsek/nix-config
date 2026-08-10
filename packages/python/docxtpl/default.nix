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
    lxml
    poetry-core
    poetry-dynamic-versioning
    python-docx
    setuptools
    six
    ;
  inherit (self.packages.${system}) docxcompose;
in
buildPythonPackage rec {
  pname = "docxtpl";
  version = "0.20.2";
  pyproject = true;

  pythonRemoveDeps = [ "black" ];

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7d8zUNcLTRIyCOgB1YW8sxPSEESjd6FPdaZtCWWEHeE=";
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
