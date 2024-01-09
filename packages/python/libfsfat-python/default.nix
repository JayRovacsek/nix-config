{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfsfat-python";
  name = pname;
  version = "20231122";

  meta = with lib; {
    description = "Python bindings module for libfsfat";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsfat/";
    downloadPage = "https://github.com/libyal/libfsfat/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TTUUb1px9EfX0DQzOsrD4bEnL1THxw/kvU+II6tDgxE=";
  };

  doCheck = false;
}
