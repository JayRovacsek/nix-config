{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  pname = "phonenumberslite";
  version = "8.13.50";

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

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rk3yr0uNT+lv+D4YTCdEColq3DzAxk8XIxkm7jzm4QA=";
  };
}
