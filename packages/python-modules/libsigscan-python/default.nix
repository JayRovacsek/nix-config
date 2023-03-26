{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "libsigscan-python";
  name = pname;
  version = "20230109";

  meta = with lib; {
    description = "Python bindings module for libsigscan";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libsigscan/";
    downloadPage = "https://github.com/libyal/libsigscan/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T6Da1vG5gl+LGQmfuAP7wjnMpBCNo5hkA8bzmGvx/2M=";
  };

  doCheck = false;
}
