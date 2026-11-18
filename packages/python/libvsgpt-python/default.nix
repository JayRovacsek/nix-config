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
  pname = "libvsgpt-python";
  version = "20260911";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libvsgpt/releases/download/20260911/libvsgpt-experimental-20260911.tar.gz";
    hash = "sha256-69HRXHgoslHloFbmhOugeZmjJ+aWht1pJv2i8d4+Buc=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyvsgpt" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvsgpt";
    downloadPage = "https://github.com/libyal/libvsgpt/releases";
    homepage = "https://github.com/libyal/libvsgpt";
    license = licenses.lgpl3Plus;
  };
}
