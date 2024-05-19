{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "phonenumberslite";
  version = "8.13.33";

  meta = with lib; {
    description = "phonenumbers Python Library";
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    downloadPage = "https://github.com/daviddrysdale/python-phonenumbers/tags";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname version meta;

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dCa8Rq895agApMjzOrE+MyJdLI7U/FKqPAOA2t2Nc4E=";
  };
}
