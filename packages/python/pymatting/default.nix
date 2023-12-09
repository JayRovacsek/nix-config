{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "PyMatting";
  name = pname;
  version = "1.1.12";

  meta = with lib; {
    description = "PyMatting: A Python Library for Alpha Matting";
    platforms = platforms.all;
    homepage = "https://github.com/pymatting/pymatting";
    downloadPage = "https://github.com/pymatting/pymatting/releases";
    license = licenses.mit;
  };

  inherit (python3Packages) buildPythonPackage numpy pillow numba scipy;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y50V1LyvsmriG4ZIwmMLgcTsqxdW/iSUOpEcW6d1xOU=";
  };

  doCheck = false;

  propagatedBuildInputs = [ numpy pillow numba scipy ];

}
