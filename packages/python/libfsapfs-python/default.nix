{
  lib,
  zlib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools;
in
buildPythonPackage rec {
  pname = "libfsapfs-python";
  version = "20240429";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ibxeT0WjT2GlcfMhEz1NAWTUGnIatuqyKur+XbWcKe0=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsapfs" ];

  meta = rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsapfs";
    downloadPage = "https://github.com/libyal/libfsapfs/releases";
    homepage = "https://github.com/libyal/libfsapfs";
    license = lib.licenses.lgpl3Plus;
  };
}
