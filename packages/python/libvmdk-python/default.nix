{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libvmdk-python";
  name = pname;
  version = "20231123";

  meta = with lib; {
    description = "Python bindings module for libvmdk";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvmdk/";
    downloadPage = "https://github.com/libyal/libvmdk/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tqlJBLNlterh/sR2CmjKl2gotfGR9qHCfa9NqrTBl2E=";
  };

  doCheck = false;
}
