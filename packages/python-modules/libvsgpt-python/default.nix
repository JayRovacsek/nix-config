{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "libvsgpt-python";
  name = pname;
  version = "20221029";

  meta = with lib; {
    description = "Python bindings module for libvsgpt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvsgpt/";
    downloadPage = "https://github.com/libyal/libvsgpt/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2GipPvRMA0viWQKIBCnp+PiLLpo4F0OeuNm0zMQ/SSU=";
  };

  doCheck = false;
}
