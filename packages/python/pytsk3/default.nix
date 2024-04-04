{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "pytsk3";

  version = "20231007";

  meta = with lib; {
    description =
      "Python bindings for the sleuthkit (http://www.sleuthkit.org/)";
    platforms = platforms.all;
    homepage = "https://github.com/py4n6/pytsk/";
    downloadPage = "https://github.com/py4n6/pytsk/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uPE5ytLj+sv/fp1AYjwIdrHLRQU/EVnDZQEGwcK6T/g=";
  };

  doCheck = false;
}
