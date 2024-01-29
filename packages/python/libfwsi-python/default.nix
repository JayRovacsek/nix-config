{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfwsi-python";
  name = pname;
  version = "20240120";

  meta = with lib; {
    description = "Python bindings module for libfwsi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfwsi/";
    downloadPage = "https://github.com/libyal/libfwsi/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J21uWdkEH+dA0AzbzJo93Npd/VCda/B95F+afv6Q5rs=";
  };

  doCheck = false;
}
