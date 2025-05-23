{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in
buildPythonPackage rec {
  pname = "dfdatetime";
  version = "20240504";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WE/6UBEpkUSv2kyrtVrOxP4Gk2RaymKGQWEPQT9ra20=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.8";

  pythonImportsCheck = [ pname ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "dfDateTime, or Digital Forensics date and time, provides date and time objects to preserve accuracy and precision.";
    homepage = "https://github.com/log2timeline/dfdatetime";
    downloadPage = "https://github.com/log2timeline/dfdatetime/releases";
    license = licenses.asl20;
  };
}
