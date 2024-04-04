{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfsext-python";

  version = "20240301";

  meta = with lib; {
    description = "Python bindings module for libfsext";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsext/";
    downloadPage = "https://github.com/libyal/libfsext/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BZ8Jta4YoGMraoSbVheYi5BV8AdWjbPi142BdvRTW7g=";
  };
}
