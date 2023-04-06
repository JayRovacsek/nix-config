{ lib, fetchPypi, python, ... }:
let
  pname = "libfsext-python";
  name = pname;
  version = "20220829";

  meta = with lib; {
    description = "Python bindings module for libfsext";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsext/";
    downloadPage = "https://github.com/libyal/libfsext/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uldQDxEpImrl5oDw3Sy9Axj+oveqx6jhrS4HMeI/R5M=";
  };

  doCheck = false;
}
