{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libregf-python";

  version = "20240303";

  meta = with lib; {
    description = "Python bindings module for libregf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libregf/";
    downloadPage = "https://github.com/libyal/libregf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-L3us7wNT9uc2KaGUFpqXyD44wud2cP3towqzpy2xy2Y=";
  };
}
