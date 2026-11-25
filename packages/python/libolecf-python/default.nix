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
  pname = "libolecf-python";
  version = "20260526";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libolecf/releases/download/20260526/libolecf-alpha-20260526.tar.gz";
    hash = "sha256-ov/OcSg+pRVv4oVvXJuhxNbNk7TXxHUA2BaETqgr2qo=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyolecf" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libolecf";
    downloadPage = "https://github.com/libyal/libolecf/releases";
    homepage = "https://github.com/libyal/libolecf";
    license = licenses.lgpl3Plus;
  };
}
