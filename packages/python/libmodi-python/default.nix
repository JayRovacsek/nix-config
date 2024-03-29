{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libmodi-python";
  name = pname;
  version = "20231123";

  meta = with lib; {
    description = "Python bindings module for libmodi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libmodi/";
    downloadPage = "https://github.com/libyal/libmodi/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EknrAFpLCTz3z08Bn1KCwPByBF+8vP+dWiCqJFbb51k=";
  };

  doCheck = false;
}
