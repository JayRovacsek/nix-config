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
  pname = "libfshfs-python";
  version = "20240501";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jme2+FiWW7hGGmpuvm2HsdRiLUCX+rizxsh5FSk/kDY=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfshfs" ];

  meta = with lib; {
    description = "Python bindings module for libfshfs";

    homepage = "https://github.com/libyal/libfshfs";
    downloadPage = "https://github.com/libyal/libfshfs/releases";
    license = licenses.lgpl3Plus;
  };
}
