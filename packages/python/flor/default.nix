{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "Flor";
  name = pname;
  version = "1.1.3";

  meta = with lib; {
    description = "Flor - An efficient Bloom filter implementation in Python";
    platforms = platforms.all;
    homepage = "https://github.com/DCSO/flor";
    downloadPage = "https://github.com/DCSO/flor/releases";
    license = licenses.bsd3;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-H6wQHhYURtuy7lN51blQuwFf5tkFaDhaVJtTjKEv6UI=";
  };

  doCheck = false;
}
