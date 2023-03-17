{ lib, stdenv, fetchPypi, python }:
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

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;
  nativeBuildInputs = [ ];

  src = fetchPypi {
    inherit pname version;
    sha256 = lib.fakeHash;
  };

  doCheck = false;
}
