{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libfsapfs-python";
  name = pname;
  version = "20231122";

  meta = with lib; {
    description = "Python bindings module for libfsapfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsapfs/";
    downloadPage = "https://github.com/libyal/libfsapfs/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CQ+/xVuNvW5P6Kqc+9TWnjw9znTqK+y/9jL14CfwZ70=";
  };

  doCheck = false;
}
