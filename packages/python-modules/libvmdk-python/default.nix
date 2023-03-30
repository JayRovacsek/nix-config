{ self, system, lib, stdenv, zlib, fetchPypi, python }:
let
  pname = "libvmdk-python";
  name = pname;
  version = "20221124";

  meta = with lib; {
    description = "Python bindings module for libvmdk";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvmdk/";
    downloadPage = "https://github.com/libyal/libvmdk/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gUgogP/ccPfO5auRKEd5Q5B0GrRIleLt+By3LXiOYXo=";
  };

  doCheck = false;
}
