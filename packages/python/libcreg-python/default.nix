{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libcreg-python";

  version = "20240303";

  meta = with lib; {
    description = "Python bindings module for libcreg";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libcreg/";
    downloadPage = "https://github.com/libyal/libcreg/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XifcgjvyRISGhGbWXx4jUv3/2V3eizbK7ljOSyKYkE8=";
  };
}
