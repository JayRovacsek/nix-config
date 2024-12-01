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
  pname = "libfsntfs-python";
  version = "20240501";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ga0MahssX2o+s1QzojxJCG1AwtnrMzw9TtzyuMbIKBk=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsntfs" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsntfs";
    homepage = "https://github.com/libyal/libfsntfs";
    downloadPage = "https://github.com/libyal/libfsntfs/releases";
    license = licenses.lgpl3Plus;
  };
}
