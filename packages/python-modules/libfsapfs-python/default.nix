{ self, system, lib, stdenv, zlib, fetchPypi, python }:
let
  pname = "libfsapfs-python";
  name = pname;
  version = "20221102";

  meta = with lib; {
    description = "Python bindings module for libfsapfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsapfs/";
    downloadPage = "https://github.com/libyal/libfsapfs/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v6lD23VJXONC59QC2kkZ2KdThUSXuv7qBdgFXWPu3Wc=";
  };

  doCheck = false;
}
