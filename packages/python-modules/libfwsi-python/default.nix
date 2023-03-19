{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "libfwsi-python";
  name = pname;
  version = "20230114";

  meta = with lib; {
    description = "Python bindings module for libfwsi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfwsi/";
    downloadPage = "https://github.com/libyal/libfwsi/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ReYmz0jfoTfkWwjqSaPhzp5x7RE5jTlInGLi324wCQc=";
  };

  doCheck = false;
}
