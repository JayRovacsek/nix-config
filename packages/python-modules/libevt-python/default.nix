{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "libevt-python";
  name = pname;
  version = "20221022";

  meta = with lib; {
    description = "Python bindings module for libevt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libevt/";
    downloadPage = "https://github.com/libyal/libevt/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mzPp2iFc8e60V4oEacai9V0H/xnNzoqMgGTtA9Rkvyc=";
  };

  doCheck = false;
}
