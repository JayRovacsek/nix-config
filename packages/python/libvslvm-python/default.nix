{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libvslvm-python";
  name = pname;
  version = "20231122";

  meta = with lib; {
    description = "Python bindings module for libvslvm";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvslvm/";
    downloadPage = "https://github.com/libyal/libvslvm/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XsHGlO0dgn66tP7But4/g5eratIotuoCIcUhNcSO5Yg=";
  };

  doCheck = false;
}
