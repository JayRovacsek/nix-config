{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "liblnk-python";
  name = pname;
  version = "20230205";

  meta = with lib; {
    description = "Python bindings module for liblnk";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/liblnk/";
    downloadPage = "https://github.com/libyal/liblnk/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kgLwfYe7MPj5AYmCJMYna+wFMo3V8A62eNVQnVU8J0k=";
  };

  doCheck = false;
}
