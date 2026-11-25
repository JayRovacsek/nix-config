{
  lib,
  zlib,
  fetchurl,
  pkg-config,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools wheel;
in
buildPythonPackage rec {
  pname = "libfshfs-python";
  version = "20260922";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libfshfs/releases/download/20260922/libfshfs-experimental-20260922.tar.gz";
    hash = "sha256-ROK5L7n25UB0YV6r62kIRz6yDwDP0FymOIAq15TGoGc=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyfshfs" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfshfs";
    downloadPage = "https://github.com/libyal/libfshfs/releases";
    homepage = "https://github.com/libyal/libfshfs";
    license = licenses.lgpl3Plus;
  };
}
