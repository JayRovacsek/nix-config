{ lib, stdenv, fetchPypi, python }:
let
  pname = "libfsntfs-python";
  name = pname;
  version = "20221023";

  meta = with lib; {
    description = "Python bindings module for libfsntfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsntfs/";
    downloadPage = "https://github.com/libyal/libfsntfs/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;
  nativeBuildInputs = [ ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tjdkHy/ttKVlGucC9/0bk9ni2J5LdvD07e/mOLX25Zg=";
  };

  doCheck = false;
}
