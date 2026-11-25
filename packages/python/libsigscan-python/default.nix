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
  pname = "libsigscan-python";
  version = "20260902";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libsigscan/releases/download/20260902/libsigscan-experimental-20260902.tar.gz";
    hash = "sha256-Zgj2NvhpGRirzFuqzPz+Vjppze9mz6bOrUTpJihjc38=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pysigscan" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libsigscan";
    downloadPage = "https://github.com/libyal/libsigscan/releases";
    homepage = "https://github.com/libyal/libsigscan";
    license = licenses.lgpl3Plus;
  };
}
