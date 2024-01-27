{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libqcow-python";
  name = pname;
  version = "20231125";

  meta = with lib; {
    description = "Python bindings module for libqcow";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libqcow/";
    downloadPage = "https://github.com/libyal/libqcow/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Eqhwx9rPO0zvA9pETmhadOsXrBhS2Htz7ueUxWuWmtA=";
  };

  doCheck = false;
}
