{ lib, fetchPypi, python, ... }:
let
  pname = "phonenumberslite";
  version = "8.13.18";

  meta = with lib; {
    description = "phonenumbers Python Library";
    platforms = platforms.all;
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    downloadPage = "https://github.com/daviddrysdale/python-phonenumbers/tags";
    license = licenses.asl20;
  };

  inherit (python) buildPythonPackage;

  propagatedBuildInputs = [ ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oyHw3s8+TggPAF/aP7paeR2dFKPKIXl0NF/0UpI8MeI=";
  };

  doCheck = false;

in buildPythonPackage {
  inherit pname version meta propagatedBuildInputs src doCheck;
}
