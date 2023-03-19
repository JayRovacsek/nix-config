{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "libvslvm-python";
  name = pname;
  version = "20221025";

  meta = with lib; {
    description = "Python bindings module for libvslvm";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvslvm/";
    downloadPage = "https://github.com/libyal/libvslvm/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IUqSzlsTqZcqYBBXjY4MyRnOL6/Ks4FgBVN3fi70uA8=";
  };

  doCheck = false;
}
