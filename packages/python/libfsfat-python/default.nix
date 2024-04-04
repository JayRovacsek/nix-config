{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfsfat-python";

  version = "20240220";

  meta = with lib; {
    description = "Python bindings module for libfsfat";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsfat/";
    downloadPage = "https://github.com/libyal/libfsfat/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eABliX9tg+AMjbtr0g1BbjZUbgJE+uIljCB7GIMWs2w=";
  };
}
