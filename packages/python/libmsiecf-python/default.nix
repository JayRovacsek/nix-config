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
  pname = "libmsiecf-python";
  version = "20260525";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libmsiecf/releases/download/20260525/libmsiecf-alpha-20260525.tar.gz";
    hash = "sha256-uPhNELT7nfpZJnEZA+FjGY1nP6NhnF3DISKKSOS2cB8=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pymsiecf" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libmsiecf";
    downloadPage = "https://github.com/libyal/libmsiecf/releases";
    homepage = "https://github.com/libyal/libmsiecf";
    license = licenses.lgpl3Plus;
  };
}
