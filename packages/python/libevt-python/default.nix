{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libevt-python";

  version = "20240203";

  meta = with lib; {
    description = "Python bindings module for libevt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libevt/";
    downloadPage = "https://github.com/libyal/libevt/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XT305BDAsBzKua85ze7QuAgdjkcW6AZHn88PFwbyeiE=";
  };
}
