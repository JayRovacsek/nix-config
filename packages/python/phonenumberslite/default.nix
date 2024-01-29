{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "phonenumberslite";
  version = "8.13.29";

  meta = with lib; {
    description = "phonenumbers Python Library";
    platforms = platforms.all;
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    downloadPage = "https://github.com/daviddrysdale/python-phonenumbers/tags";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage;

  propagatedBuildInputs = [ ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KwSlNAHQGrQlZMGrx2L8mAitOY5x2s+js41DIeES7LM=";
  };

  doCheck = false;

in buildPythonPackage {
  inherit pname version meta propagatedBuildInputs src doCheck;
}
