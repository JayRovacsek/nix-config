{
  lib,
  fetchurl,
  pkg-config,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools wheel;
in
buildPythonPackage rec {
  pname = "libcreg-python";
  version = "20260523";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libcreg/releases/download/20260523/libcreg-experimental-20260523.tar.gz";
    hash = "sha256-JcsZ5cW8eUzTInIkU+DWBxVuug8AE/n8lPJ24Vxrwn8=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pycreg" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libcreg";
    downloadPage = "https://github.com/libyal/libcreg/releases";
    homepage = "https://github.com/libyal/libcreg";
    license = licenses.lgpl3Plus;
  };
}
