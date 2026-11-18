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
  pname = "libevt-python";
  version = "20260705";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libevt/releases/download/20260705/libevt-alpha-20260705.tar.gz";
    hash = "sha256-wUFgzY/neCQ88f5AlEaaABSg3Qjl6H+86xxM7dZWLUU=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyevt" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libevt";
    downloadPage = "https://github.com/libyal/libevt/releases";
    homepage = "https://github.com/libyal/libevt";
    license = licenses.lgpl3Plus;
  };
}
