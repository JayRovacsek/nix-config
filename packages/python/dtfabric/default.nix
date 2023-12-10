{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "dtfabric";
  name = pname;
  version = "20230520";

  meta = with lib; {
    description =
      "dtFabric, or data type fabric, is a project to manage data types and structures, as used in the libyal projects.";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/dtfabric/";
    downloadPage = "https://github.com/libyal/dtfabric/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage pyyaml;

in buildPythonPackage {
  inherit pname name version meta;
  propagatedBuildInputs = [ pyyaml ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rJPBEe/eAQ7OPPZHeFbomkb8ca3WTheDhs/ic6GohVM=";
  };

  doCheck = false;
}
