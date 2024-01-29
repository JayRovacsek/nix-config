{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libbde-python";
  name = pname;
  version = "20231220";

  meta = with lib; {
    description =
      "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files.";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libbde/";
    downloadPage = "https://github.com/libyal/libbde/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9zHbjhEjuzxXlp7TTZESuKkCZxY1NLKRaH+70ZCQOD0=";
  };

  doCheck = false;
}
