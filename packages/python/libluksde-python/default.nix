{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libluksde-python";

  version = "20240114";

  meta = with lib; {
    description = "Python bindings module for libluksde";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libluksde/";
    downloadPage = "https://github.com/libyal/libluksde/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3memvir7wBXruXgmVG83aw6NI/T/jIw2mWnJFuoPuBc=";
  };
}
