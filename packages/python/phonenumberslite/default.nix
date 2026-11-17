{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  pname = "phonenumberslite";
  version = "9.0.43";

  meta = with lib; {
    description = "phonenumbers Python Library";
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    downloadPage = "https://github.com/daviddrysdale/python-phonenumbers/tags";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in
buildPythonPackage {
  inherit pname version meta;
  pyproject = true;

  nativeBuildInputs = [
    setuptools
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gpgR7tsXD/jsx67+0tkTZuhA2usoEXSK290VkYkW4rE=";
  };
}
