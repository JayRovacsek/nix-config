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
  pname = "libfvde-python";
  version = "20260923";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libfvde/releases/download/20260923/libfvde-experimental-20260923.tar.gz";
    hash = "sha256-bXVb7t9QB155nXwbltA3ukCGulLCL6SvSFyJ2PZrHos=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyfvde" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfvde";
    downloadPage = "https://github.com/libyal/libfvde/releases";
    homepage = "https://github.com/libyal/libfvde";
    license = licenses.lgpl3Plus;
  };
}
