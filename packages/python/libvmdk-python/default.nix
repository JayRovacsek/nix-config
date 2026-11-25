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
  pname = "libvmdk-python";
  version = "20260714";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libvmdk/releases/download/20260714/libvmdk-alpha-20260714.tar.gz";
    hash = "sha256-j0KYGKrAm9BFfm9VDTnnBXh4VvdSPXs8gsqo7nWWeLE=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyvmdk" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvmdk";
    downloadPage = "https://github.com/libyal/libvmdk/releases";
    homepage = "https://github.com/libyal/libvmdk";
    license = licenses.lgpl3Plus;
  };
}
