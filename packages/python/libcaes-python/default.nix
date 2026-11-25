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
  pname = "libcaes-python";
  version = "20261028";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libcaes/releases/download/20261028/libcaes-alpha-20261028.tar.gz";
    hash = "sha256-cq87HLINb9v1ZPnw8wvjtKkwpN2dHugHBZQmC132Bxc=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pycaes" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libcaes";
    downloadPage = "https://github.com/libyal/libcaes/releases";
    homepage = "https://github.com/libyal/libcaes";
    license = licenses.lgpl3Plus;
  };
}
