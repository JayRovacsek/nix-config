{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libluksde-python";
  name = pname;
  version = "20221103";

  meta = with lib; {
    description = "Python bindings module for libluksde";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libluksde/";
    downloadPage = "https://github.com/libyal/libluksde/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gPpmClunyK3QE889K30TK/gX2uGbVHQ3sjSWq67B5fY=";
  };

  doCheck = false;
}