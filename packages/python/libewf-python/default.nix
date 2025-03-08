{
  lib,
  zlib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in
buildPythonPackage rec {
  pname = "libewf-python";
  version = "20240506";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QSgdeDQTblS12naUkiZtR24cVQWyRadVzglZapgphUI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyewf" ];

  meta = rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libewf";
    downloadPage = "https://github.com/libyal/libewf/releases";
    homepage = "https://github.com/libyal/libewf";
    license = lib.licenses.lgpl3Plus;
  };
}
