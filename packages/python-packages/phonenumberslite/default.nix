{ lib, fetchPypi, python, ... }:
let
  pname = "phonenumberslite";
  version = "8.13.17";

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
    hash = "sha256-V0HeS3epY/M1hesOj/omMuqZh9blCjisZ/RB5JQi3mk=";
  };

  doCheck = false;

in buildPythonPackage {
  inherit pname version meta propagatedBuildInputs src doCheck;
}
