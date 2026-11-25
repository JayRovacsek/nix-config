{
  lib,
  fetchurl,
  pkg-config,
  python3Packages,
  ...
}:
let
  inherit (python3Packages)
    buildPythonPackage
    pythonOlder
    setuptools
    wheel
    ;
in
buildPythonPackage rec {
  pname = "libfwnt-python";
  version = "20260602";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libfwnt/releases/download/20260602/libfwnt-alpha-20260602.tar.gz";
    hash = "sha256-rlF/wkfcc6Dc8F5GaEXFa75K0dD1SOzoQqTemOvwYag=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [
    setuptools
    wheel
  ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyfwnt" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfwnt";
    downloadPage = "https://github.com/libyal/libfwnt/releases";
    homepage = "https://github.com/libyal/libfwnt";
    license = licenses.lgpl3Plus;
  };
}
