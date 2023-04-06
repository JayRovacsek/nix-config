{ lib, zlib, fetchPypi, python, ... }:
let
  pname = "libewf-python";
  name = pname;
  version = "20230212";

  meta = with lib; {
    description = "Python bindings module for libewf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libewf/";
    downloadPage = "https://github.com/libyal/libewf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a7bPJVovPukGWrOV1peM314w9alB3Kk+Ow1WMlD5+LA=";
  };

  doCheck = false;
}
