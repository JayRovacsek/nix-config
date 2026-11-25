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
  pname = "libvhdi-python";
  version = "20260901";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libvhdi/releases/download/20260901/libvhdi-alpha-20260901.tar.gz";
    hash = "sha256-tcbxC5S96luQL8dKmE8K5MKbm7JPgbYxjFs41gu6JPI=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyvhdi" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvhdi";
    downloadPage = "https://github.com/libyal/libvhdi/releases";
    homepage = "https://github.com/libyal/libvhdi";
    license = licenses.lgpl3Plus;
  };
}
