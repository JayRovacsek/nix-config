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
  pname = "libewf-python";
  version = "20260924";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libewf/releases/download/20260924/libewf-experimental-20260924.tar.gz";
    hash = "sha256-4tpP24mZuFWUiGPRvLEelCevlZ54kJNJHtlNyjl5BbU=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyewf" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libewf";
    downloadPage = "https://github.com/libyal/libewf/releases";
    homepage = "https://github.com/libyal/libewf";
    license = licenses.lgpl3Plus;
  };
}
