{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libvhdi-python";
  name = pname;
  version = "20231127";

  meta = with lib; {
    description = "Python bindings module for libvhdi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvhdi/";
    downloadPage = "https://github.com/libyal/libvhdi/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KOR9r0lUxlR999s4H/mmbk4FbAzzXBECxRIo7lTvZGY=";
  };

  doCheck = false;
}
