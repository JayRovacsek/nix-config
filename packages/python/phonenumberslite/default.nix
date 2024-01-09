{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "phonenumberslite";
  version = "8.13.26";

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
    hash = "sha256-Y1byco+h0sK8nnnDv8/tyRo2U333oTTxUHMaghpGmpY=";
  };

  doCheck = false;

in buildPythonPackage {
  inherit pname version meta propagatedBuildInputs src doCheck;
}
