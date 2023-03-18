{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "libfsxfs-python";
  name = pname;
  version = "20220829";

  meta = with lib; {
    description = "Python bindings module for libfsxfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsxfs/";
    downloadPage = "https://github.com/libyal/libfsxfs/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;
  nativeBuildInputs = [ ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mNvSLO/B69zQILEcVTTbL3YXJJJOm0o74SG2HZ0+U0M=";
  };

  doCheck = false;
}
