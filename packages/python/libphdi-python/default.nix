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
  pname = "libphdi-python";
  version = "20260902";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libphdi/releases/download/20260902/libphdi-experimental-20260902.tar.gz";
    hash = "sha256-hOIsoi4K/axIrKpvMhzMM8f9deLa3jalzLNc0d1vzPQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyphdi" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libphdi";
    downloadPage = "https://github.com/libyal/libphdi/releases";
    homepage = "https://github.com/libyal/libphdi";
    license = licenses.lgpl3Plus;
  };
}
