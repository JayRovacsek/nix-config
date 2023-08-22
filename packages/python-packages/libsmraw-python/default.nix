{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libsmraw-python";
  name = pname;
  version = "20221028";

  meta = with lib; {
    description = "Python bindings module for libsmraw";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libsmraw/";
    downloadPage = "https://github.com/libyal/libsmraw/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g9Rfwie7+Q1aUmWnhc0ysscfh3ZCXpV0g0Gv1AM4cek=";
  };

  doCheck = false;
}
