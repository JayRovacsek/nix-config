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
  pname = "libfcrypto-python";
  version = "20260521";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libfcrypto/releases/download/20260521/libfcrypto-alpha-20260521.tar.gz";
    hash = "sha256-xih60bWFFxtmkMQqWkTCrpT2DQc9odsefV3NX5hCwZE=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyfcrypto" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfcrypto";
    downloadPage = "https://github.com/libyal/libfcrypto/releases";
    homepage = "https://github.com/libyal/libfcrypto";
    license = licenses.lgpl3Plus;
  };
}
