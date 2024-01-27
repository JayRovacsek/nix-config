{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libfshfs-python";
  name = pname;
  version = "20231125";

  meta = with lib; {
    description = "Python bindings module for libfshfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfshfs/";
    downloadPage = "https://github.com/libyal/libfshfs/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+33dWr2dHfgaDS30YYHYO2+4KBdWQG0XnFbA/rQE6ck=";
  };

  doCheck = false;
}
