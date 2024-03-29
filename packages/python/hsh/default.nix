{ pkgs, lib, fetchPypi, python3Packages, self, ... }:
let
  inherit (pkgs) system;

  pname = "hsh";
  name = pname;
  version = "1.1.0";

  meta = with lib; {
    description =
      "hsh is a cross-platform command line application that generates file hash digests and performs file integrity checks via file hash digest comparisons.";
    platforms = platforms.all;
    homepage = "https://github.com/chrissimpkins/hsh";
    downloadPage = "https://github.com/chrissimpkins/hsh/releases";
    license = licenses.mit;
  };

  inherit (python3Packages) buildPythonPackage;

  inherit (self.packages.${system}) commandlines;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wE5DrFOP6vsCnbo8SXIgenBPX83w7icevd3QPZa134U=";
  };

  propagatedBuildInputs = [ commandlines ];
}
