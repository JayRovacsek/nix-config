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
  pname = "libfsext-python";
  version = "20260821";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libfsext/releases/download/20260821/libfsext-experimental-20260821.tar.gz";
    hash = "sha256-HQbAD7B3wAEQoOWVhVXPGuk0HtQ2pMGtR1E/BTBGaqs=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyfsext" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsext";
    downloadPage = "https://github.com/libyal/libfsext/releases";
    homepage = "https://github.com/libyal/libfsext";
    license = licenses.lgpl3Plus;
  };
}
