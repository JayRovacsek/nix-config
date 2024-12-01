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
  pname = "libfvde-python";
  version = "20240502";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QEJ4VEXkLryDMPzqsuTkRSJfcG1/kKuhJ/WHy4Lq/nQ=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfvde" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfvde";
    downloadPage = "https://github.com/libyal/libfvde/releases";
    homepage = "https://github.com/libyal/libfvde";
    license = licenses.lgpl3Plus;
  };
}
