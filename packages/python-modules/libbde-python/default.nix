{ lib, fetchPypi, python, ... }:
let
  pname = "libbde-python";
  name = pname;
  version = "20221031";

  meta = with lib; {
    description =
      "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files.";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libbde/";
    downloadPage = "https://github.com/libyal/libbde/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-62n9EgbdokMmmh3KQnFJdVZLVaRYc2ARyTwRJ10jOzA=";
  };

  doCheck = false;
}
