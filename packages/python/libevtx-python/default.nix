{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libevtx-python";

  version = "20240204";

  meta = with lib; {
    description = "Python bindings module for libevtx";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libevtx/";
    downloadPage = "https://github.com/libyal/libevtx/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ndEyCnp8H8D9y8bw5i3noEeSMo+R9FmavaM/FeQbCyI=";
  };
}
