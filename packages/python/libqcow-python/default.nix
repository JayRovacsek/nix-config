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
  pname = "libqcow-python";
  version = "20260703";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libqcow/releases/download/20260703/libqcow-alpha-20260703.tar.gz";
    hash = "sha256-1y8m8MBhCWC8Aux8Zksp1TweV0QFKk7uqIXtUCkowEs=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyqcow" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libqcow";
    downloadPage = "https://github.com/libyal/libqcow/releases";
    homepage = "https://github.com/libyal/libqcow";
    license = licenses.lgpl3Plus;
  };
}
