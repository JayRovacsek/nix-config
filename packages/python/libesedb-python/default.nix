{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libesedb-python";
  name = pname;
  version = "20231120";

  meta = with lib; {
    description = "Python bindings module for libesedb";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libesedb/";
    downloadPage = "https://github.com/libyal/libesedb/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fHGYgxwW0Xmj/swip3eNedsex2pWozKAYVsuR+qce9c=";
  };

  doCheck = false;
}
