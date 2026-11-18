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
  pname = "libscca-python";
  version = "20260527";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libscca/releases/download/20260527/libscca-alpha-20260527.tar.gz";
    hash = "sha256-X6ijq2ArRDHnXmH00h69RhdMUkp5Fz+MDq3KJM3b3BY=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyscca" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libscca";
    downloadPage = "https://github.com/libyal/libscca/releases";
    homepage = "https://github.com/libyal/libscca";
    license = licenses.lgpl3Plus;
  };
}
