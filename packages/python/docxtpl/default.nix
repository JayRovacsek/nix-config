{ pkgs, lib, fetchPypi, python3Packages, self, ... }:
let
  inherit (pkgs) system;

  pname = "docxtpl";
  version = "0.16.7";

  meta = with lib; {
    description = "Use a docx as a jinja2 template";
    platforms = platforms.all;
    homepage = "https://github.com/elapouya/python-docx-template";
    downloadPage = "https://github.com/elapouya/python-docx-template/tags";
    license = licenses.lgpl21;
  };

  inherit (python3Packages) buildPythonPackage six python-docx jinja2 lxml;

  inherit (self.packages.${system}) docxcompose;

  propagatedBuildInputs = [
    six
    (python-docx.overridePythonAttrs
      (_: { disabledTests = [ "DescribeParseXml" ]; }))
    jinja2
    lxml
    docxcompose
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cXTBfmWBFK3jHharORKFZ8q7pbtYs3OhsuUJ2StRjDk=";
  };

in buildPythonPackage { inherit pname version meta propagatedBuildInputs src; }
