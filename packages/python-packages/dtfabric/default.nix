{ lib, fetchPypi, python, ... }:
let
  pname = "dtfabric";
  name = pname;
  version = "20221218";

  meta = with lib; {
    description =
      "dtFabric, or data type fabric, is a project to manage data types and structures, as used in the libyal projects.";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/dtfabric/";
    downloadPage = "https://github.com/libyal/dtfabric/releases";
    license = licenses.asl20;
  };

  inherit (python) buildPythonPackage pyyaml;

in buildPythonPackage {
  inherit pname name version meta;
  propagatedBuildInputs = [ pyyaml ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E4HOdIBj0Mcy/PNDStwXmsjwW3WpZJYmFDDWvRaTPlU=";
  };

  doCheck = false;
}
