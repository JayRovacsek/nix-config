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
  pname = "libesedb-python";
  version = "20260704";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libesedb/releases/download/20260704/libesedb-experimental-20260704.tar.gz";
    hash = "sha256-ePXkzRG1UeZz2ycKnUCr88jshSO5GTmpJRyoDuWoO9E=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyesedb" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libesedb";
    downloadPage = "https://github.com/libyal/libesedb/releases";
    homepage = "https://github.com/libyal/libesedb";
    license = licenses.lgpl3Plus;
  };
}
