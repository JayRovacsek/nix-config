{ lib, fetchPypi, python, ... }:
let
  pname = "libsmdev-python";
  name = pname;
  version = "20221028";

  meta = with lib; {
    description = "Python bindings module for libsmdev";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libsmdev/";
    downloadPage = "https://github.com/libyal/libsmdev/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7UYGsw/udeXdQozYSiqPUPEyGQhYPoC3yQlrmmYJUb0=";
  };

  doCheck = false;
}
