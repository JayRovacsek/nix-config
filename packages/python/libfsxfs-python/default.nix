{ lib, fetchPypi, python3Packages, ... }:
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

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mNvSLO/B69zQILEcVTTbL3YXJJJOm0o74SG2HZ0+U0M=";
  };

  doCheck = false;
}
