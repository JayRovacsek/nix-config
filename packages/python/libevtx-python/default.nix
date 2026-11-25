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
  pname = "libevtx-python";
  version = "20260705";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libevtx/releases/download/20260705/libevtx-alpha-20260705.tar.gz";
    hash = "sha256-NIacOgHgSh6q4rCfOrExLLq0WgXMlacFkreD8WW2F8A=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyevtx" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libevtx";
    downloadPage = "https://github.com/libyal/libevtx/releases";
    homepage = "https://github.com/libyal/libevtx";
    license = licenses.lgpl3Plus;
  };
}
