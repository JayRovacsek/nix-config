{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libscca-python";
  name = pname;
  version = "20231203";

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
    sha256 = "sha256-IXqsDBjwYwa93+Ovq5mUlg5dCst3q2Z/QE+aM66W1iE=";
  };

  doCheck = false;
}
