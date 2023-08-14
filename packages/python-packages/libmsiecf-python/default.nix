{ lib, fetchPypi, python, ... }:
let
  pname = "libmsiecf-python";
  name = pname;
  version = "20221024";

  meta = with lib; {
    description = "Python bindings module for libmsiecf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libmsiecf/";
    downloadPage = "https://github.com/libyal/libmsiecf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8Ch7mVkgUFEFWquOq/oamOTFd63/vQ1QOuxTdVSoiLg=";
  };

  doCheck = false;
}
