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
  pname = "libregf-python";
  version = "20260526";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libregf/releases/download/20260526/libregf-alpha-20260526.tar.gz";
    hash = "sha256-TNoYugWLSwgFJVGT3iQSgQLS9mBa5UhTu4DYTvpD08U=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyregf" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libregf";
    downloadPage = "https://github.com/libyal/libregf/releases";
    homepage = "https://github.com/libyal/libregf";
    license = licenses.lgpl3Plus;
  };
}
