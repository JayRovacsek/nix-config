{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libscca-python";
  name = pname;
  version = "20240120";

  meta = with lib; {
    description = "Python bindings module for libscca";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libscca/";
    downloadPage = "https://github.com/libyal/libscca/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vVnl8n21GIf4rhuPTkrs3XcWKBT4fZKZyv//8xRvNYY=";
  };

  doCheck = false;
}
