{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libvshadow-python";
  name = pname;
  version = "20231128";

  meta = with lib; {
    description = "Python bindings module for libvshadow";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvshadow/";
    downloadPage = "https://github.com/libyal/libvshadow/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-B1B7le2SHjnF5ds/7eqburL7WVk/ANmsPS1tDbZcTPQ=";
  };

  doCheck = false;
}
