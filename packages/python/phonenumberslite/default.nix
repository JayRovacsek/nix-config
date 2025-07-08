{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  pname = "phonenumberslite";
  version = "9.0.0";

  meta = with lib; {
    description = "phonenumbers Python Library";
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    downloadPage = "https://github.com/daviddrysdale/python-phonenumbers/tags";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage;

in
buildPythonPackage {
  inherit pname version meta;
  pyproject = true;

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k8PhZ57V87GqEESISi3XWKDv/rEnLj9S+7foDCM8yYo=";
  };
}
