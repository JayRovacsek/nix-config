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
  pname = "libsmdev-python";
  version = "20260902";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libsmdev/releases/download/20260902/libsmdev-alpha-20260902.tar.gz";
    hash = "sha256-8oWpGlq61SW5IvCzPCvb9XS6W16CZQNbntBz3sblzf4=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pysmdev" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libsmdev";
    downloadPage = "https://github.com/libyal/libsmdev/releases";
    homepage = "https://github.com/libyal/libsmdev";
    license = licenses.lgpl3Plus;
  };
}
