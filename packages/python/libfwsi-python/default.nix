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
  pname = "libfwsi-python";
  version = "20260522";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libfwsi/releases/download/20260522/libfwsi-experimental-20260522.tar.gz";
    hash = "sha256-fX/XJgXyscVM5z8ZsuAcJ5oLivY6HNYalaltzhcN5h0=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyfwsi" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfwsi";
    downloadPage = "https://github.com/libyal/libfwsi/releases";
    homepage = "https://github.com/libyal/libfwsi";
    license = licenses.lgpl3Plus;
  };
}
