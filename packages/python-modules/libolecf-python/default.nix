{ lib, fetchPypi, python, ... }:
let
  pname = "libolecf-python";
  name = pname;
  version = "20221024";

  meta = with lib; {
    description = "Python bindings module for libolecf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libolecf/";
    downloadPage = "https://github.com/libyal/libolecf/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Wtj5f5NRxzc4x49Gh6gqIJ4UZvcEPuGp6NiAqry23qQ=";
  };

  doCheck = false;
}
