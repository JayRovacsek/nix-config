{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in
buildPythonPackage rec {
  pname = "libluksde-python";
  version = "20240503";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vBNIQQ3Q0aJoaKoKytH5cxi7GluZYaJLzBPy7hXUUqw=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyluksde" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libluksde";
    downloadPage = "https://github.com/libyal/libluksde/releases";
    homepage = "https://github.com/libyal/libluksde";
    license = licenses.lgpl3Plus;
  };
}
