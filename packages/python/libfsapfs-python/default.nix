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
  pname = "libfsapfs-python";
  version = "20261030";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libfsapfs/releases/download/20261030/libfsapfs-experimental-20261030.tar.gz";
    hash = "sha256-xyfSMZevPyyeOWGFRcRxk2ZjOmZnJbg74qMhSkihHfU=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyfsapfs" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsapfs";
    downloadPage = "https://github.com/libyal/libfsapfs/releases";
    homepage = "https://github.com/libyal/libfsapfs";
    license = licenses.lgpl3Plus;
  };
}
