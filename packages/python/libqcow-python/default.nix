{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libqcow-python";
  name = pname;
  version = "20221124";

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
    sha256 = "sha256-p0CdNcT3t2KdiTp1g00gw9tsxmuoKXInfyQBhg+64nI=";
  };

  doCheck = false;
}
