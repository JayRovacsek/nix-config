{ lib, zlib, fetchPypi, python3Packages, ... }:
let
  pname = "libfvde-python";
  name = pname;
  version = "20231128";

  meta = with lib; {
    description = "Python bindings module for libfvde";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfvde/";
    downloadPage = "https://github.com/libyal/libfvde/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-InW4qbmjkloWktSk396qEhxO3MVTjCFMAW0apnK1QXk=";
  };

  doCheck = false;
}
