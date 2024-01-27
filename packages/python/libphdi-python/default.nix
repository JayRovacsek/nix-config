{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libphdi-python";
  name = pname;
  version = "20231129";

  meta = with lib; {
    description = "Python bindings module for libphdi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libphdi/";
    downloadPage = "https://github.com/libyal/libphdi/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G06vL2FpeO5o3O+Qu1YWfrLJJ3+JICvF85Dsgu3RrJA=";
  };

  doCheck = false;
}
