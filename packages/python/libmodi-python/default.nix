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
  pname = "libmodi-python";
  version = "20260902";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libmodi/releases/download/20260902/libmodi-experimental-20260902.tar.gz";
    hash = "sha256-GgvxQ2UOwnk1RIwQZGIT9SfXJJW/6pbYmuEOc5+aSv0=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pymodi" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libmodi";
    downloadPage = "https://github.com/libyal/libmodi/releases";
    homepage = "https://github.com/libyal/libmodi";
    license = licenses.lgpl3Plus;
  };
}
