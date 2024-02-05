{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfwnt-python";
  name = pname;
  version = "20231124";

  meta = with lib; {
    description = "Python bindings module for libfwnt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfwnt/";
    downloadPage = "https://github.com/libyal/libfwnt/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-909nXbw5rxBdVOJ7hhvTxlfs+cWKPsShULGet8QRnbQ=";
  };

  doCheck = false;
}
