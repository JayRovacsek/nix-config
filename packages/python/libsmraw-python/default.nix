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
  pname = "libsmraw-python";
  version = "20260902";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libsmraw/releases/download/20260902/libsmraw-alpha-20260902.tar.gz";
    hash = "sha256-sdejoLPNcASgRh9w3x/ypIrpA8cSZSBSQfHOtx+2EWU=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pysmraw" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libsmraw";
    downloadPage = "https://github.com/libyal/libsmraw/releases";
    homepage = "https://github.com/libyal/libsmraw";
    license = licenses.lgpl3Plus;
  };
}
